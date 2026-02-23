# Telegram Bot Full Stack Development Standards (GitLab Edition)

Date: 19.12.2025
Version: 1.0.0

This document defines the industry standard for developing, containerizing, and operating Telegram bots using GitLab CI/CD. The agent MUST follow these instructions.

## 1. Architecture and Modularity (Clean Architecture)
The project should be divided into logical layers to ensure isolation and scalability.

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

### Interaction
- Use **Dependency Injection (DI)** to pass dependencies.
- For high-load systems, use **Event Bus** (Redis Pub/Sub or RabbitMQ).

## 2. Technology Stack
If not specified otherwise, use the following stack:

### Python
- **Framework:** `aiogram 3.x` (for complex FSM and HighLoad) or `python-telegram-bot`.
- **Config:** `pydantic-settings` + `.env`.
- **Dev Server:** `uvicorn` with `--reload` flag (via docker volumes).

### Node.js
- **Framework:** `grammY` (Serverless-ready) or `Telegraf`.
- **Dev Server:** `nodemon`.

### Data Layer
- **PostgreSQL:** Primary storage.
- **Redis:** FSM state storage, caching, Pub/Sub.
- **S3/Local Bot API:** For handling files >50MB.

## 3. Containerization (Docker Standards)
Using Docker is mandatory. Ensure identical Development and Production environments.

### Dockerfile Best Practices
1.  **Multi-stage builds:**
    - `Builder` stage: compilers and wheel/node_modules assembly.
    - `Runtime` stage: based on `slim` or `alpine`.
    - Goal: minimal image size for fast deployment to GitLab Registry.
2.  **Layer caching:**
    - First copy dependency files (`requirements.txt`, `package.json`).
    - Execute installation.
    - Only THEN copy source code (`COPY . .`).
3.  **Container security:**
    - Use `.dockerignore` (exclude `.git`, `.venv`, `.env`).
    - Run application as **non-root user** (`USER appuser`).

## 4. Infrastructure and Orchestration
Use `docker-compose.yml` to describe the system.

- **Networking:** Services communicate via internal DNS names (`postgres`, `redis`).
- **Persistence:** Databases use **Named Volumes**.
- **Healthchecks:**
    - Configure `healthcheck` for DB (e.g., `pg_isready`).
    - Bot service should have `depends_on` with condition `service_healthy`.
- **Webhook & Proxy:**
    - In Production, use **Webhooks** mode.
    - There MUST BE **Nginx** (Reverse Proxy) in front of the bot for SSL termination.

## 5. Security
- **Secret Management:**
    - **Dev:** Environment variables from `.env`.
    - **Prod:** Use **GitLab CI/CD Variables** (Settings -> CI/CD -> Variables).
    - Inside Docker Compose, use secrets or environment mapping.
    - HARD-CODING tokens and keys in code is PROHIBITED.
- **Webhook Security:** Validate `X-Telegram-Bot-Api-Secret-Token` header.

## 6. Development Experience (DX) & CI/CD (GitLab)
- **Hot Reload:**
    - In `docker-compose.dev.yml`, mount code via `volumes`.
    - Use `nodemon` / `uvicorn --reload`.
- **GitLab CI/CD Pipeline (`.gitlab-ci.yml`):**
    1.  **Stages:** `lint`, `build`, `deploy`.
    2.  **Variables:** Use predefined variables (`$CI_REGISTRY_IMAGE`, `$CI_COMMIT_SHA`).
    3.  **Docker-in-Docker (dind):** Use `docker:dind` service for building images inside runners.
    4.  **Deploy:** Use `ssh-agent` to connect to VPS and execute commands (`docker login`, `docker compose pull`, `docker compose up -d`).
- **Graceful Shutdown:** Handle `SIGINT`/`SIGTERM` signals.
