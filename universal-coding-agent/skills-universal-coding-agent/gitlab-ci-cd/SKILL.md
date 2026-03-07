---
name: gitlab-ci-cd
description: Setting up CI/CD pipelines with GitLab CI/CD. Use this skill when creating pipelines for testing, building, deploying applications using GitLab's CI/CD platform, including Docker builds, multi-stage pipelines, and deployment workflows.
---

# GitLab CI/CD Guide

## Basics

### Pipeline Structure

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""

before_script:
  - echo "Running before script"

after_script:
  - echo "Running after script"

lint:
  stage: lint
  image: node:20
  script:
    - npm ci
    - npm run lint
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"

test:
  stage: test
  image: node:20
  script:
    - npm ci
    - npm test
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
  dependencies:
    - lint

build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_TAG

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - apk add --no-cache curl
    - curl -X POST $DEPLOY_WEBHOOK
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

## Node.js / JavaScript CI

### Full CI/CD Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - deploy

variables:
  NODE_VERSION: "20"
  NPM_CONFIG_CACHE: "$CI_PROJECT_DIR/.npm"

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .npm/
    - .cache/

lint:
  stage: lint
  image: node:${NODE_VERSION}
  script:
    - npm ci --prefer-offline
    - npm run lint
    - npm run typecheck
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

test:
  stage: test
  image: node:${NODE_VERSION}
  script:
    - npm ci --prefer-offline
    - npm test -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
  parallel:
    matrix:
      - NODE_VERSION: ["18", "20", "22"]

build:
  stage: build
  image: node:${NODE_VERSION}
  script:
    - npm ci --prefer-offline
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

deploy:
  stage: deploy
  image: node:${NODE_VERSION}
  script:
    - npm ci --prefer-offline
    - npm run deploy
  environment:
    name: production
    url: https://example.com
    on_stop: stop_deploy
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  when: manual

stop_deploy:
  stage: deploy
  image: node:${NODE_VERSION}
  script:
    - npm run deploy:rollback
  environment:
    name: production
    action: stop
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  when: manual
```

## Python CI

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - deploy

variables:
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"
  PYTHON_VERSION: "3.11"

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .cache/pip
    - .venv/

.python_version:
  image: python:${PYTHON_VERSION}
  before_script:
    - python -m venv .venv
    - source .venv/bin/activate
    - pip install --upgrade pip
    - pip install -r requirements.txt

lint:
  stage: lint
  extends: .python_version
  script:
    - pip install flake8 black isort mypy
    - flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
    - black --check .
    - isort --check-only --diff .
    - mypy .
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

test:
  stage: test
  extends: .python_version
  script:
    - pip install pytest pytest-cov httpx
    - pytest --cov=src --cov-report=xml --cov-report=html --junitxml=junit.xml
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - htmlcov/
    expire_in: 1 week
  parallel:
    matrix:
      - PYTHON_VERSION: ["3.10", "3.11", "3.12"]

build:
  stage: build
  extends: .python_version
  script:
    - pip install build
    - python -m build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

deploy:
  stage: deploy
  extends: .python_version
  script:
    - pip install twine
    - twine upload --skip-existing dist/*
  environment:
    name: pypi
    url: https://pypi.org
  rules:
    - if: $CI_COMMIT_TAG
```

## Docker Build & Push

### Basic Docker Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - push

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""
  IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

docker-build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG .
    - docker tag $IMAGE_TAG $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_TAG

docker-test:
  stage: test
  image: $IMAGE_TAG
  script:
    - docker run $IMAGE_TAG npm test
  needs:
    - docker-build

docker-push:
  stage: push
  image: docker:24-dind
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - |
      if [ -n "$CI_COMMIT_TAG" ]; then
        docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
      fi
  rules:
    - if: $CI_COMMIT_TAG
```

### Multi-Platform Docker Build

```yaml
# .gitlab-ci.yml
docker-buildx:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker buildx create --name mybuilder --use --bootstrap
    - docker buildx build
      --push
      --tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
      --tag $CI_REGISTRY_IMAGE:latest
      --platform linux/amd64,linux/arm64
      .
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_TAG
```

## FastAPI / Python Web App Deploy

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - build
  - deploy

variables:
  PYTHON_VERSION: "3.11"
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .cache/pip
    - .venv/

.linux-fallback:
  image: python:${PYTHON_VERSION}-slim
  before_script:
    - apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev
    - python -m venv .venv
    - source .venv/bin/activate
    - pip install --upgrade pip
    - pip install -r requirements.txt
    - pip install -r requirements-dev.txt

lint:
  extends: .linux-fallback
  stage: lint
  script:
    - black --check .
    - isort --check-only --diff .
    - mypy .
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

test:
  extends: .linux-fallback
  stage: test
  script:
    - pytest --cov=app --cov-report=xml --cov-report=html --junitxml=junit.xml
    - pytest --cov=app --cov-report=term
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

docker-build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_TAG

deploy-staging:
  stage: deploy
  image: ubuntu:22.04
  before_script:
    - apt-get update && apt-get install -y openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh $DEPLOY_USER@$STAGING_HOST "cd /app && docker-compose pull && docker-compose up -d"
  environment:
    name: staging
    url: https://staging.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
  when: manual

deploy-production:
  stage: deploy
  image: ubuntu:22.04
  before_script:
    - apt-get update && apt-get install -y openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh $DEPLOY_USER@$PROD_HOST "cd /app && docker-compose pull && docker-compose up -d"
  environment:
    name: production
    url: https://api.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  when: manual
```

## Testing and Security

### Security Scanning

```yaml
# .gitlab-ci.yml
stages:
  - test
  - security

dependency-scanning:
  stage: security
  image: node:20
  allow_failure: true
  script:
    - npm install
    - npm audit --audit-level=high || true
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  artifacts:
    reports:
      dependency_scanning: gl-dependency-scanning-report.json

sast:
  stage: security
  image: node:20
  allow_failure: true
  script:
    - npm install
    - npm audit --audit-level=high || true
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  artifacts:
    reports:
      sast: gl-sast-report.json

container-scanning:
  stage: security
  image: docker:24-dind
  services:
    - docker:24-dind
  allow_failure: true
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code=0 --severity HIGH,CRITICAL $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  artifacts:
    reports:
      container_scanning: gl-container-scanning-report.json

secret-detection:
  stage: security
  image: alpine:latest
  script:
    - apk add --no-cache git
    - git clone https://github.com/trufflesecurity/trufflehog.git /trufflehog
    - cd /trufflehog && go install
    - trufflehog filesystem . --json | tee secret-detection-report.json || true
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  artifacts:
    reports:
      secret_detection: secret-detection-report.json
```

## DAST (Dynamic Application Security Testing)

```yaml
# .gitlab-ci.yml
stages:
  - security
  - deploy
  - dast

dast:
  stage: dast
  image: owasp/zap2docker-stable:latest
  allow_failure: true
  script:
    - zap-baseline.py -t $STAGING_URL -r zap_report.html
  artifacts:
    reports:
      dast: zap_report.html
    paths:
      - zap_report.html
  environment:
    name: staging
    url: https://staging.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"
  when: manual
```

## Matrix Builds

```yaml
# .gitlab-ci.yml
test:
  stage: test
  image: node:${NODE_VERSION}
  parallel:
    matrix:
      - NODE_VERSION: ["18", "20", "22"]
        DATABASE: "postgres:15"
      - NODE_VERSION: ["18", "20", "22"]
        DATABASE: "mysql:8"
  script:
    - npm ci
    - npm test
  services:
    - name: ${DATABASE}
      alias: db
  variables:
    DATABASE_URL: postgres://postgres:postgres@db:5432/test
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

## Caching

```yaml
# .gitlab-ci.yml
cache:
  key: ${CI_COMMIT_REF_SLUG}-{{ checksum "package-lock.json" }}
  paths:
    - .npm/
    - .cache/pip
    - .venv/
  policy: pull-push

npm-cache:
  image: node:20
  cache:
    key: npm-${CI_COMMIT_REF_SLUG}
    paths:
      - .npm/
  script:
    - npm ci

pip-cache:
  image: python:3.11
  cache:
    key: pip-${CI_COMMIT_REF_SLUG}
    paths:
      - .cache/pip
  script:
    - pip install -r requirements.txt

docker-cache:
  image: docker:24-dind
  services:
    - docker:24-dind
  cache:
    key: docker-${CI_COMMIT_BRANCH}
    paths:
      - /tmp/.docker-cache
  script:
    - docker build --cache-from $CI_REGISTRY_IMAGE:cache -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
```

## Review Apps

```yaml
# .gitlab-ci.yml
stages:
  - deploy

review:
  stage: deploy
  image: node:20
  script:
    - npm ci
    - npm run build
    - npm run deploy:review
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: https://$CI_COMMIT_REF_SLUG.example.com
    on_stop: stop_review
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  when: manual

stop_review:
  stage: deploy
  image: node:20
  script:
    - npm run destroy:review
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  when: manual
```

## GitOps / Kubernetes Deploy

```yaml
# .gitlab-ci.yml
stages:
  - build
  - deploy

docker-build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

deploy:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config set-cluster k8s --server=$KUBE_URL --certificate-authority-data=$KUBE_CA_CERT
    - kubectl config set-credentials deployer --token=$KUBE_TOKEN
    - kubectl config set-context default --cluster=k8s --user=deployer --namespace=$KUBE_NAMESPACE
    - kubectl config use-context default
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl rollout status deployment/app
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
  when: manual
```

## Notifications

```yaml
# .gitlab-ci.yml
notify:
  stage: .post
  image: alpine:latest
  script:
    - apk add --no-cache curl jq
    - |
      if [ "$CI_JOB_STATUS" == "success" ]; then
        MESSAGE="✅ Pipeline succeeded for $CI_PROJECT_NAME
        Branch: $CI_COMMIT_BRANCH
        Commit: $CI_COMMIT_TITLE"
      else
        MESSAGE="❌ Pipeline failed for $CI_PROJECT_NAME
        Branch: $CI_COMMIT_BRANCH
        Commit: $CI_COMMIT_TITLE"
      fi
    - curl -X POST "$DISCORD_WEBHOOK" -H "Content-Type: application/json" -d "{\"content\": \"$MESSAGE\"}"
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

## Best Practices

1. **Use `rules`** - Control when jobs run (MRs, branches, tags)
2. **Cache dependencies** - npm, pip, docker layers
3. **Use templates (extends)** - Reusable job configurations
4. **Parallel jobs** - Speed up pipelines with matrix builds
5. **Artifacts** - Pass built files between stages
6. **Environment protection** - Secure production deployments
7. **Manual actions** - Require approval for deployments
8. **Secrets** - Use GitLab CI/CD variables, never hardcode
9. **Idempotency** - Pipeline should be restartable
10. **Timeout** - Set reasonable job timeout (default 1 hour)
11. **Fail fast** - Lint and type check before expensive tests
12. **Optimize Docker** - Multi-stage builds, .dockerignore
13. **Security scanning** - SAST, DAST, dependency scanning
14. **Review apps** - Auto-deploy branches for review
15. **GitOps** - Declarative Kubernetes deployments

## GitLab CI/CD vs GitHub Actions Comparison

| Feature | GitLab CI/CD | GitHub Actions |
|---------|--------------|----------------|
| Config file | `.gitlab-ci.yml` | `.github/workflows/*.yml` |
| Main container | `image:` | `runs-on:` |
| Services | `services:` | `services:` |
| Caching | `cache:` | `cache:` |
| Artifacts | `artifacts:` | `artifacts:` |
| Environment | `environment:` | `environment:` |
| Conditional | `rules:` | `if:` |
| Reusable jobs | `extends:` | `uses:` |
| Matrix | `parallel:matrix:` | `strategy:matrix:` |
| Secrets | CI/CD Variables | Secrets |
| Registry | GitLab Container Registry | GitHub Container Registry |
