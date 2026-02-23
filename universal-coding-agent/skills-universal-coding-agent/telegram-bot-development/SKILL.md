---
name: telegram-bot-development
description: Telegram bot development with GitLab CI/CD. Use this skill when creating Telegram bots with Docker containerization, Clean Architecture, and automated deployment pipelines.
---

# Telegram Bot Development Guide

This skill covers full-stack Telegram bot development including architecture, containerization, CI/CD pipelines, and production deployment.

## 1. Architecture and Modularity (Clean Architecture)

The project MUST be divided into logical layers to ensure isolation and scalability.

### Layer Structure

- **Core:** Initialization, loggers, config loading (`.env` / `pydantic-settings`).
- **Handlers:**
  - Contain ONLY command receiving and routing logic.
  - BUSINESS LOGIC or SQL QUERIES are PROHIBITED inside handlers.
  - Grouped by FSM states or domains.
- **Services:**
  - Encapsulate business logic (payments, analytics, user operations).
  - Must be asynchronous and independent of Telegram objects (`Update`, `Message`).
- **Database:**
  - Work through repositories and ORM (SQLAlchemy, Prisma).
  - Migrations (Alembic) are mandatory.
- **Middlewares:** Logging, authentication, throttling.

### Interaction Pattern

```
Handlers → Services → Database
     ↓
  Core (Config, Logger)
```

- Use **Dependency Injection (DI)** to pass dependencies.
- For high-load systems, use **Event Bus** (Redis Pub/Sub or RabbitMQ).

## 2. Technology Stack

If not specified otherwise, use the following stack:

### Python

- **Framework:** `aiogram 3.x` (for complex FSM and HighLoad) or `python-telegram-bot`
- **Config:** `pydantic-settings` + `.env`
- **Dev Server:** `uvicorn` with `--reload` flag (via docker volumes)

### Node.js

- **Framework:** `grammY` (Serverless-ready) or `Telegraf`
- **Dev Server:** `nodemon`

### Data Layer

- **PostgreSQL:** Primary storage
- **Redis:** FSM state storage, caching, Pub/Sub
- **S3/Local Bot API:** For handling files >50MB

## 3. Containerization (Docker Standards)

Using Docker is **mandatory**. Ensure identical Development and Production environments.

### Dockerfile Best Practices

```dockerfile
# Multi-stage build for Python (aiogram)
FROM python:3.11-slim AS builder

WORKDIR /app

# Install dependencies first (better caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Final stage
FROM python:3.11-slim

WORKDIR /app

# Copy only installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000
CMD ["python", "-m", "app"]
```

```dockerfile
# Multi-stage build for Node.js (grammY)
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Create non-root user
RUN addgroup -g 1000 -S nodejs && \
    adduser -S nodejs -u 1000
USER nodejs

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Dockerfile Rules

1. **Multi-stage builds:**
   - `Builder` stage: compilers and wheel/node_modules assembly
   - `Runtime` stage: based on `slim` or `alpine`
   - Goal: minimal image size for fast deployment to GitLab Registry

2. **Layer caching:**
   - First copy dependency files (`requirements.txt`, `package.json`)
   - Execute installation
   - Only THEN copy source code (`COPY . .`)

3. **Container security:**
   - Use `.dockerignore` (exclude `.git`, `.venv`, `.env`)
   - Run application as **non-root user** (`USER appuser`)

### .dockerignore Example

```
.git
.gitignore
.env
.env.*
*.md
venv/
node_modules/
dist/
__pycache__/
*.pyc
.DS_Store
```

## 4. Infrastructure and Orchestration

Use `docker-compose.yml` to describe the system.

### Development Compose

```yaml
version: '3.8'

services:
  bot:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/app
      - /app/node_modules  # or /usr/local/lib/python3.11/site-packages
    env_file:
      - .env
    command: npm run dev  # or uvicorn app:app --reload
    ports:
      - "3000:3000"

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: botdb
      POSTGRES_USER: botuser
      POSTGRES_PASSWORD: botpass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U botuser -d botdb"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Production Compose

```yaml
version: '3.8'

services:
  bot:
    image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_SHA}
    restart: always
    env_file:
      - .env.production
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started

  postgres:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_DB: botdb
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    restart: always
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - bot

volumes:
  postgres_data:
  redis_data:
```

### Nginx Configuration for Webhooks

```nginx
events {
    worker_connections 1024;
}

http {
    upstream bot {
        server bot:3000;
    }

    server {
        listen 80;
        server_name your-domain.com;

        location /webhook {
            proxy_pass http://bot;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            
            # Security: validate secret token
            proxy_set_header X-Telegram-Bot-Api-Secret-Token $http_x_telegram_bot_api_secret_token;
        }

        location /health {
            proxy_pass http://bot/health;
            access_log off;
        }
    }
}
```

## 5. GitLab CI/CD Pipeline

Create `.gitlab-ci.yml` with the following stages:

### Pipeline Structure

```yaml
stages:
  - lint
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

.lint_job: &lint_job
  stage: lint
  image: node:20-alpine
  before_script:
    - npm ci
  script:
    - npm run lint
  only:
    - merge_requests
    - main

.python_lint_job: &python_lint_job
  stage: lint
  image: python:3.11-slim
  before_script:
    - pip install flake8
  script:
    - flake8 . --max-line-length=120 --ignore=E501,W503
  only:
    - merge_requests
    - main

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker build -t $CI_REGISTRY_IMAGE:latest .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
  when: manual

deploy:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add openssh-client curl
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST "
        docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY &&
        docker compose -f docker-compose.yml pull &&
        docker compose -f docker-compose.yml up -d
      "
  environment:
    name: production
    url: https://your-domain.com
  only:
    - main
  when: manual
```

### Required GitLab CI/CD Variables

Configure in **Settings → CI/CD → Variables**:

| Variable | Type | Description |
|----------|------|-------------|
| `BOT_TOKEN` | Masked | Telegram Bot API Token |
| `SSH_PRIVATE_KEY` | Masked | SSH private key for deploy |
| `DEPLOY_HOST` | Variable | Server hostname/IP |
| `DEPLOY_USER` | Variable | SSH username |
| `DB_PASSWORD` | Masked | PostgreSQL password |
| `REDIS_PASSWORD` | Masked | Redis password |

## 6. Security

### Secret Management

- **Development:** Environment variables from `.env`
- **Production:** Use **GitLab CI/CD Variables** (Settings → CI/CD → Variables)
- Inside Docker Compose, use secrets or environment mapping
- **HARDCODING tokens and keys in code is PROHIBITED**

### Webhook Security

Always validate `X-Telegram-Bot-Api-Secret-Token` header:

```python
# aiogram example
from aiogram import Bot, Dispatcher, Router
from aiogram.filters import SecretToken
from aiogram.webhook.aiohttp import AiohttpWebhookRequestHandler

router = Router()

@router.message(SecretToken())
async def handle_message(message: Message, bot: Bot):
    await bot.send_message(message.chat.id, "Hello!")

# In production, verify the token
SECRET_TOKEN = os.getenv("TELEGRAM_SECRET_TOKEN")

def setup_webhook():
    handler = AiohttpWebhookRequestHandler(
        secret_token=SECRET_TOKEN,
        router=router
    )
```

```javascript
// grammY example
import { Bot, webhookCallback } from "grammy";

const bot = new Bot(process.env.BOT_TOKEN!);

const SECRET_TOKEN = process.env.TELEGRAM_SECRET_TOKEN;

bot.on("message", async (ctx) => {
  await ctx.reply("Hello!");
});

// Express server with webhook
import express from "express";
const app = express();

app.use(webhookCallback(bot, "express", {
  secretToken: SECRET_TOKEN,
}));

app.listen(3000, () => {
  console.log("Bot is running on port 3000");
});
```

### Security Checklist

- [ ] Never hardcode secrets in code
- [ ] Use environment variables for all sensitive data
- [ ] Validate X-Telegram-Bot-Api-Secret-Token in production
- [ ] Run containers as non-root user
- [ ] Use TLS/SSL in production (Nginx)
- [ ] Rotate secrets regularly
- [ ] Use GitLab protected variables for production

## 7. Code Examples

### Python (Aiogram 3.x)

```python
# app/core/config.py
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    bot_token: str
    database_url: str
    redis_url: str
    secret_token: str = "change_me"
    
    class Config:
        env_file = ".env"


@lru_cache()
def get_settings():
    return Settings()


settings = get_settings()
```

```python
# app/handlers/commands.py
from aiogram import Router
from aiogram.types import Message
from aiogram.filters import CommandStart

router = Router()


@router.message(CommandStart())
async def cmd_start(message: Message):
    await message.answer(
        f"Hello, {message.from_user.first_name}!\n"
        "I'm a Telegram bot."
    )
```

```python
# app/services/user_service.py
from app.models import User
from sqlalchemy.ext.asyncio import AsyncSession


class UserService:
    def __init__(self, session: AsyncSession):
        self.session = session
    
    async def get_or_create(self, telegram_id: int, username: str):
        user = await self.session.get(User, telegram_id)
        if not user:
            user = User(telegram_id=telegram_id, username=username)
            self.session.add(user)
            await self.session.commit()
        return user
```

### Node.js (Grammy)

```typescript
// src/config.ts
import { z } from "zod";

const configSchema = z.object({
  BOT_TOKEN: z.string(),
  DATABASE_URL: z.string(),
  REDIS_URL: z.string(),
  SECRET_TOKEN: z.string().optional(),
});

export const config = configSchema.parse(process.env);
```

```typescript
// src/bot.ts
import { Bot } from "grammy";
import { run } from "@grammyjs/runner";

export const bot = new Bot(process.env.BOT_TOKEN!);

bot.command("start", async (ctx) => {
  await ctx.reply(`Hello, ${ctx.from.first_name}!`);
});

bot.on("message:text", async (ctx) => {
  await ctx.reply("You said: " + ctx.message.text);
});

// Graceful shutdown
process.on("SIGINT", async () => {
  await bot.stop();
  process.exit(0);
});
```

## 8. Development Workflow

### Local Development

1. Create `.env` file:
   ```
   BOT_TOKEN=your_token_here
   DATABASE_URL=postgresql://botuser:botpass@localhost:5432/botdb
   REDIS_URL=redis://localhost:6379
   ```

2. Start services:
   ```bash
   docker compose -f docker-compose.dev.yml up -d
   ```

3. Enable webhook mode locally:
   ```bash
   ngrok http 3000
   # Set webhook: https://api.telegram.org/bot<TOKEN>/setWebhook?url=https://<NGROK_URL>/webhook
   ```

### Production Deployment

1. Configure GitLab CI/CD variables
2. Push to `main` branch
3. Run `build` job manually
4. Run `deploy` job manually
5. Set webhook: `https://api.telegram.org/bot<TOKEN>/setWebhook?url=https://your-domain.com/webhook`

## 9. Best Practices

### Do's

- Use Clean Architecture (Handlers → Services → Database)
- Always use Docker for consistency
- Implement proper error handling and logging
- Use database migrations (Alembic/Drizzle)
- Handle graceful shutdown (SIGINT/SIGTERM)
- Validate webhook secret token in production
- Use PostgreSQL for production data
- Use Redis for FSM and caching

### Don'ts

- Never hardcode secrets in code
- Never run containers as root
- Never use SQLite in production
- Never skip webhook secret validation
- Never disable TLS/SSL in production
- Don't put business logic in handlers
- Don't skip database migrations

## 10. Quick Reference

### Common Commands

```bash
# Build Docker image
docker build -t mybot .

# Run locally
docker compose -f docker-compose.dev.yml up

# Set webhook
curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook" \
  -d "url=https://your-domain.com/webhook"

# Get webhook info
curl "https://api.telegram.org/bot<TOKEN>/getWebhookInfo"

# Delete webhook
curl -X POST "https://api.telegram.org/bot<TOKEN>/deleteWebhook"
```

### File Structure

```
telegram-bot/
├── app/                      # Application code
│   ├── core/               # Config, logger, DB
│   ├── handlers/           # Telegram handlers
│   ├── services/           # Business logic
│   ├── models/              # Database models
│   └── middlewares/         # Middlewares
├── docker-compose.yml       # Production compose
├── docker-compose.dev.yml   # Development compose
├── Dockerfile
├── .dockerignore
├── .env.example
├── requirements.txt         # Python dependencies
└── package.json            # Node.js dependencies
```
