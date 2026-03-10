---
name: python-project-setup
description: Setting up a new Python project using modern tools and best practices. Use this skill when creating a new Python project, setting up a virtual environment, configuring dependencies, Docker, and CI/CD pipelines. Includes hybrid Django + FastAPI architecture patterns.
---

# Python Project Setup Guide

## Overview

This skill covers the complete setup of modern Python projects including hybrid architectures (Django + FastAPI), Docker configuration, environment requirements, troubleshooting, production readiness checklist, and GitLab CI/CD pipelines.

---

## 1. Project Structure (Hybrid Architecture)

### Django + FastAPI Hybrid Structure

For projects combining Django backend with FastAPI microservices:

```
project-root/
├── backend/                     # Django application
│   ├── config/                 # Django settings
│   │   ├── __init__.py
│   │   ├── settings.py         # Main settings
│   │   ├── settings_dev.py    # Development settings
│   │   ├── settings_prod.py   # Production settings
│   │   └── urls.py
│   ├── apps/                   # Django apps
│   │   ├── users/
│   │   ├── products/
│   │   └── orders/
│   ├── core/                   # Core functionality
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   └── urls.py
│   ├── static/                 # Static files
│   ├── media/                  # User uploads
│   ├── manage.py
│   └── requirements.txt
├── api/                        # FastAPI microservices
│   ├── main.py                # FastAPI app entry
│   ├── api_v1/                # API version 1
│   │   ├── endpoints/
│   │   │   ├── users.py
│   │   │   ├── products.py
│   │   │   └── orders.py
│   │   └── router.py
│   ├── core/
│   │   ├── config.py
│   │   ├── security.py
│   │   └── database.py
│   ├── schemas/                # Pydantic models
│   ├── models/                 # SQLAlchemy models
│   └── services/
├── frontend/                   # Frontend (React/Next.js)
├── docker/                     # Docker configurations
│   ├── docker-compose.yml
│   ├── nginx/
│   │   ├── Dockerfile
│   │   └── nginx.conf
│   └── django/
│       └── Dockerfile
├── scripts/                    # Management scripts
│   ├── init_db.sh
│   └── backup.sh
├── tests/                      # Test suites
│   ├── backend/
│   ├── api/
│   └── fixtures/
├── .env.example               # Environment template
├── .gitignore
├── pyproject.toml             # Poetry configuration
├── docker-compose.yml         # Main compose file
├── .gitlab-ci.yml            # GitLab CI/CD
└── README.md
```

### Standard Python Project Structure

```
my-python-project/
├── src/                       # Source code
│   └── my_package/           # Main package
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── models.py
│       ├── routers/
│       ├── services/
│       └── utils/
├── tests/                     # Tests
│   ├── __init__.py
│   ├── conftest.py
│   ├── unit/
│   └── integration/
├── docs/                      # Documentation
├── scripts/                    # Utility scripts
├── pyproject.toml             # Poetry configuration
├── poetry.lock
├── .env.example
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── .gitlab-ci.yml
└── README.md
```

---

## 2. Docker Configuration

### Multi-Stage Dockerfile (Recommended)

```dockerfile
# Build stage
FROM python:3.11-slim AS builder

WORKDIR /build

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Configure Poetry
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --only main

# Production stage
FROM python:3.11-slim AS production

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash appuser

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check (using urllib from stdlib - no extra dependencies needed)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Run application
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose with Nginx

```yaml
# docker-compose.yml
version: '3.8'

services:
  # Django application
  django:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: django_app
    restart: unless-stopped
    environment:
      - DEBUG=0
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/project
      - REDIS_URL=redis://redis:6379/0
      - SECRET_KEY=${SECRET_KEY}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./backend:/app
      - static_volume:/app/static
      - media_volume:/app/media
    networks:
      - backend_network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health/"]
      interval: 30s
      timeout: 10s
      retries: 3

  # FastAPI application
  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    container_name: fastapi_app
    restart: unless-stopped
    environment:
      - DEBUG=0
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/project
      - REDIS_URL=redis://redis:6379/0
      - SECRET_KEY=${SECRET_KEY}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./api:/app
    networks:
      - backend_network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8001/health/"]
      interval: 30s
      timeout: 10s
      retries: 3

  # PostgreSQL database
  db:
    image: postgres:15-alpine
    container_name: postgres_db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=project
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - backend_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis cache
  redis:
    image: redis:7-alpine
    container_name: redis_cache
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - backend_network

  # Nginx reverse proxy
  nginx:
    build:
      context: ./docker/nginx
    container_name: nginx_proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - static_volume:/app/static:ro
      - media_volume:/app/media:ro
      - ./docker/nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - django
      - api
    networks:
      - backend_network
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_data:
  redis_data:
  static_volume:
  media_volume:

networks:
  backend_network:
    driver: bridge
```

### Nginx Configuration

```nginx
# nginx/nginx.conf
upstream django_backend {
    server django:8000;
}

upstream fastapi_backend {
    server api:8001;
}

server {
    listen 80;
    server_name example.com www.example.com;
    
    client_max_body_size 100M;
    
    # Static files
    location /static/ {
        alias /app/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    
    # Media files
    location /media/ {
        alias /app/media/;
        expires 7d;
    }
    
    # API requests
    location /api/ {
        proxy_pass http://fastapi_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
    
    # Django application
    location / {
        proxy_pass http://django_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# SSL configuration (example)
# server {
#     listen 443 ssl http2;
#     server_name example.com;
#     
#     ssl_certificate /etc/nginx/ssl/cert.pem;
#     ssl_certificate_key /etc/nginx/ssl/key.pem;
#     ssl_protocols TLSv1.2 TLSv1.3;
#     ssl_ciphers HIGH:!aNULL:!MD5;
#     
#     # ... same as above
# }
```

### .dockerignore

```
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
*.egg-info/
.eggs/
.git/
.gitignore
.vscode/
.idea/
*.md
docs/
tests/
.pytest_cache/
.coverage
htmlcov/
.env
.venv/
venv/
.env.local
*.log
node_modules/
```

---

## 3. Environment Requirements

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Python | 3.10 | 3.11+ |
| PostgreSQL | 13 | 15+ |
| Redis | 6 | 7+ |
| Nginx | 1.18 | 1.24+ |
| Docker | 20.10 | 24+ |
| Docker Compose | 1.29 | 2.24+ |

### Python Version Requirements

```toml
# pyproject.toml
[tool.poetry]
name = "my-project"
version = "0.1.0"
description = "Project description"
authors = ["Your Name <email@example.com>"]
readme = "README.md"

# Python version constraints
python = "^3.10"

[tool.poetry.dependencies]
# Core dependencies
fastapi = "^0.109.0"
uvicorn = {extras = ["standard"], version = "^0.27.0"}
django = "^4.2"
djangorestframework = "^3.14"
psycopg2-binary = "^2.9"
redis = "^5.0"
pydantic = "^2.5"
pydantic-settings = "^2.1"
alembic = "^1.13"

# Additional useful packages
python-dotenv = "^1.0"
celery = "^5.3"
flower = "^2.0"
gunicorn = "^21.2"

[tool.poetry.group.dev.dependencies]
# Testing
pytest = "^7.4"
pytest-asyncio = "^0.23"
pytest-cov = "^4.1"
pytest-docker = "^2.0"
httpx = "^0.26"
factory-boy = "^3.3"

# Code quality
black = "^24.1"
isort = "^5.13"
flake8 = "^7.0"
mypy = "^1.8"
ruff = "^0.1"

# Development tools
ipython = "^8.20"
django-extensions = "^2.2"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

### Environment Variables Template

```bash
# .env.example - copy to .env and fill in values

# Application
APP_NAME=my-project
DEBUG=0
SECRET_KEY=your-secret-key-here-min-50-chars
ALLOWED_HOSTS=example.com,www.example.com

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/project
DB_ENGINE=django.db.backends.postgresql
DB_NAME=project
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432

# Redis
REDIS_URL=redis://localhost:6379/0
CELERY_BROKER_URL=redis://localhost:6379/0
CELERY_RESULT_BACKEND=redis://localhost:6379/0

# Security
CORS_ALLOWED_ORIGINS=https://example.com
CSRF_TRUSTED_ORIGINS=https://example.com

# Email (optional)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.example.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=noreply@example.com
EMAIL_HOST_PASSWORD=your-email-password

# External Services (optional)
S3_BUCKET_NAME=your-bucket
S3_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret

# Monitoring (optional)
SENTRY_DSN=
```

---

## 4. Troubleshooting

### Common Issues and Solutions

#### 1. Database Connection Errors

**Problem:** `could not connect to server: Connection refused`

**Solution:**
```bash
# Check if PostgreSQL is running
docker-compose ps
docker-compose logs db

# Test connection
docker-compose exec db psql -U postgres -c "SELECT 1;"

# Verify DATABASE_URL in .env file
cat .env | grep DATABASE_URL
```

#### 2. Import Errors

**Problem:** `ModuleNotFoundError: No module named 'module_name'`

**Solution:**
```bash
# Install dependencies
poetry install

# Verify package is installed
poetry show module_name

# Check PYTHONPATH
echo $PYTHONPATH

# Add src to path
export PYTHONPATH="${PYTHONPATH}:$(pwd)/src"
```

#### 3. Migration Errors

**Problem:** `relation "table_name" already exists`

**Solution:**
```bash
# For Django
python manage.py migrate --fake-initial

# Create migrations
python manage.py makemigrations

# For Alembic (FastAPI)
alembic upgrade head
alembic stamp head
```

#### 4. Static Files Not Loading

**Problem:** Static files return 404

**Solution:**
```bash
# Collect static files
python manage.py collectstatic --noinput

# Check nginx configuration
nginx -t

# Reload nginx
docker-compose exec nginx nginx -s reload
```

#### 5. Permission Errors

**Problem:** `Permission denied` errors

**Solution:**
```bash
# Fix ownership
sudo chown -R $USER:$USER .
chmod -R 755 .

# For media files
chmod -R 775 media/
sudo chgrp -R www-data media/

# Check Docker volume permissions
docker-compose exec app ls -la /app
```

#### 6. Memory Issues

**Problem:** Out of memory during build

**Solution:**
```dockerfile
# Add to Dockerfile
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV MALLOC_TRIM_THRESHOLD_=0
```

```yaml
# docker-compose.yml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 2G
```

#### 7. Port Conflicts

**Problem:** `port is already in use`

**Solution:**
```bash
# Find process using port
lsof -i :8000
netstat -tulpn | grep 8000

# Kill process
kill -9 <PID>

# Or use different port in docker-compose.yml
```

---

## 5. Production Readiness Checklist

### Security

- [ ] `DEBUG=False` in production
- [ ] `SECRET_KEY` is secure (50+ random characters)
- [ ] `ALLOWED_HOSTS` configured properly
- [ ] HTTPS enabled with valid SSL certificate
- [ ] CSRF protection enabled
- [ ] X-Frame-Options header set
- [ ] Content Security Policy configured
- [ ] Database credentials are secure
- [ ] Redis password set (if applicable)
- [ ] No sensitive data in code repository

### Database

- [ ] Database migrations applied
- [ ] Database backup strategy configured
- [ ] Connection pooling configured (PgBouncer)
- [ ] Database monitoring set up
- [ ] Indexes optimized for queries

### Docker & Infrastructure

- [ ] Multi-stage Dockerfile used
- [ ] Non-root user in container
- [ ] Health checks configured
- [ ] Resource limits set
- [ ] Logging configured properly
- [ ] Nginx configured with gzip compression
- [ ] Static files served via Nginx
- [ ] Proper timeout configurations

### Monitoring & Alerts

- [ ] Application logging configured
- [ ] Error tracking (Sentry) set up
- [ ] Health check endpoint available
- [ ] Prometheus metrics exposed
- [ ] Grafana dashboards configured
- [ ] Alerting rules set up

### CI/CD

- [ ] GitLab CI/CD pipeline configured
- [ ] Automatic tests on merge requests
- [ ] Code quality checks (lint, type check)
- [ ] Security scanning enabled
- [ ] Docker image builds on merge
- [ ] Deployment automation configured

### Performance

- [ ] Caching configured (Redis)
- [ ] Database query optimization
- [ ] CDN for static files (optional)
- [ ] Connection pooling enabled
- [ ] Async tasks with Celery (if needed)

---

## 6. GitLab CI/CD Pipeline

### Complete Pipeline Configuration

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - security
  - deploy

variables:
  PYTHON_VERSION: "3.11"
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"
  POETRY_CACHE_DIR: "$CI_PROJECT_DIR/.cache/poetry"

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .cache/pip
    - .cache/poetry
    - .venv/

# Base Python configuration
.python_base:
  image: python:${PYTHON_VERSION}-slim
  before_script:
    - pip install --upgrade pip
    - pip install poetry
    - poetry config virtualenvs.create false
    - poetry install --no-interaction

# Linting stage
lint:
  extends: .python_base
  stage: lint
  script:
    - pip install black isort flake8 mypy ruff
    - black --check .
    - isort --check-only --diff .
    - ruff check .
    - mypy .
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  allow_failure: true

# Unit tests
test:unit:
  extends: .python_base
  stage: test
  services:
    - postgres:15-alpine
    - redis:7-alpine
  variables:
    POSTGRES_DB: test
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: postgresql://test:test@postgres:5432/test
    REDIS_URL: redis://redis:6379/0
  script:
    - pip install pytest pytest-asyncio pytest-cov httpx
    - pytest tests/ -v --cov=src --cov-report=xml --cov-report=html --junitxml=junit.xml
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - htmlcov/
    expire_in: 7 days
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# Integration tests
test:integration:
  extends: .python_base
  stage: test
  services:
    - postgres:15-alpine
    - redis:7-alpine
  variables:
    POSTGRES_DB: test
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: postgresql://test:test@postgres:5432/test
    REDIS_URL: redis://redis:6379/0
  script:
    - pip install pytest pytest-asyncio httpx
    - pytest tests/integration/ -v --junitxml=junit-integration.xml
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  allow_failure: true

# Django-specific tests
test:django:
  extends: .python_base
  stage: test
  services:
    - postgres:15-alpine
  variables:
    POSTGRES_DB: test
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: postgresql://test:test@postgres:5432/test
  script:
    - pip install django pytest-django
    - pytest backend/tests/ -v --junitxml=junit-django.xml
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  allow_failure: true

# Docker build
docker:build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  variables:
    IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG -f backend/Dockerfile ./backend
    - docker push $IMAGE_TAG
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_TAG

# Docker build for API (FastAPI)
docker:build:api:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  variables:
    IMAGE_TAG: $CI_REGISTRY_IMAGE:api-$CI_COMMIT_SHA
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG -f api/Dockerfile ./api
    - docker push $IMAGE_TAG
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# Security scanning
security:dependency:
  extends: .python_base
  stage: security
  script:
    - pip install safety
    - safety check --json > dependency-report.json || true
  artifacts:
    reports:
      dependency_scanning: dependency-report.json
    paths:
      - dependency-report.json
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  allow_failure: true

security:secret:
  stage: security
  image: alpine:latest
  before_script:
    - apk add --no-cache git
  script:
    - git clone https://github.com/trufflesecurity/trufflehog.git /trufflehog
    - cd /trufflehog && go install
    - trufflehog filesystem . --json | tee secret-report.json || true
  artifacts:
    reports:
      secret_detection: secret-report.json
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  allow_failure: true

# Deploy to staging
deploy:staging:
  stage: deploy
  image: ubuntu:22.04
  before_script:
    - apt-get update && apt-get install -y openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - eval $(ssh-agent -k)
  script:
    - ssh $DEPLOY_USER@$STAGING_HOST "cd /app && \
      export IMAGE_TAG=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA && \
      docker-compose pull && \
      docker-compose up -d"
  environment:
    name: staging
    url: https://staging.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
  when: manual

# Deploy to production
deploy:production:
  stage: deploy
  image: ubuntu:22.04
  before_script:
    - apt-get update && apt-get install -y openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - eval $(ssh-agent -k)
  script:
    - ssh $DEPLOY_USER@$PROD_HOST "cd /app && \
      export IMAGE_TAG=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA && \
      docker-compose pull && \
      docker-compose up -d"
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  when: manual

# Notify on failure/success
notify:
  stage: .post
  image: alpine:latest
  before_script:
    - apk add --no-cache curl jq
  script:
    - |
      if [ "$CI_JOB_STATUS" == "success" ]; then
        MESSAGE="✅ Pipeline succeeded for $CI_PROJECT_NAME
        Branch: $CI_COMMIT_BRANCH
        Commit: $CI_COMMIT_TITLE"
      else
        MESSAGE="❌ Pipeline failed for $CI_PROJECT_NAME
        Branch: $CI_COMMIT_BRANCH
        Commit: $CI_COMMIT_TITLE
        Job: $CI_JOB_NAME"
      fi
      curl -X POST "$SLACK_WEBHOOK" -H "Content-Type: application/json" -d "{\"text\": \"$MESSAGE\"}"
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

### GitLab CI/CD Variables

| Variable | Description | Protected |
|---------|-------------|-----------|
| `CI_REGISTRY_IMAGE` | Docker registry image path | No |
| `CI_REGISTRY_USER` | Docker registry username | No |
| `CI_REGISTRY_PASSWORD` | Docker registry password | Yes |
| `SSH_PRIVATE_KEY` | SSH key for deployment | Yes |
| `STAGING_HOST` | Staging server hostname | No |
| `PROD_HOST` | Production server hostname | Yes |
| `DEPLOY_USER` | SSH deploy user | No |
| `SLACK_WEBHOOK` | Slack webhook URL | Yes |
| `SECRET_KEY` | Application secret key | Yes |
| `DATABASE_URL` | Production database URL | Yes |

---

## 7. Best Practices Summary

1. **Always use virtual environments** - Poetry or virtualenv
2. **Specify dependency versions** - Use constraints for critical packages
3. **Write tests from the start** - pytest with coverage
4. **Set up type checking** - mypy for static typing
5. **Use Docker** - Multi-stage builds for production
6. **Configure Nginx** - Reverse proxy with caching
7. **Set up CI/CD** - GitLab CI/CD pipeline
8. **Never store secrets** - Use environment variables
9. **Enable HTTPS** - Use Let's Encrypt or purchased certs
10. **Configure monitoring** - Sentry, Prometheus, Grafana

---

## Additional Resources

- [Poetry Documentation](https://python-poetry.org/docs/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Nginx Configuration](https://nginx.org/en/docs/)
