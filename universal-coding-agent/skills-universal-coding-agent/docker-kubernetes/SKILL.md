---
name: docker-kubernetes
description: Containerization with Docker and orchestration with Kubernetes. Use this skill when creating Dockerfile, docker-compose, Kubernetes manifests, and helm charts.
---

# Docker and Kubernetes Guide

## Docker

## Basics

```bash
# Install Docker
# macOS
brew install --cask docker

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Main commands
docker --version
docker ps              # List running containers
docker ps -a          # All containers
docker images         # List images
docker pull nginx     # Pull image
docker rmi nginx      # Remove image
```

### Dockerfile

```dockerfile
# Node.js application
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build application
RUN npm run build

# Expose port
EXPOSE 3000

# Run
CMD ["node", "dist/server.js"]
```

```dockerfile
# Python (Django/FastAPI)
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Migrations
RUN python manage.py migrate --noinput
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
```

```dockerfile
# Go application
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main .

# Minimal runtime image
FROM alpine:3.18

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
```

### Multi-stage builds

```dockerfile
# Frontend + Backend
# Stage 1: Frontend build
FROM node:18-alpine AS frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# Stage 2: Backend build
FROM node:18-alpine AS backend
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci
COPY backend/ ./
RUN npm run build

# Stage 3: Production
FROM node:18-alpine
WORKDIR /app

COPY --from=backend /app/dist ./dist
COPY --from=frontend /app/dist/public ./public

EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://redis:6379
      - NODE_ENV=development
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./data:/app/data
    networks:
      - backend

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - backend

  redis:
    image: redis:7-alpine
    command: redis-server --requirepass pass
    networks:
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - web
    networks:
      - backend

volumes:
  postgres_data:

networks:
  backend:
    driver: bridge
```

```yaml
# docker-compose.override.yml for development
version: '3.8'

services:
  web:
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    command: npm run dev
```

### Docker Compose Commands

```bash
# Start
docker-compose up -d
docker-compose up -d --build

# Stop
docker-compose down
docker-compose down -v  # with volumes

# Logs
docker-compose logs -f
docker-compose logs -f web

# Scale
docker-compose up -d --scale web=3

# Rebuild
docker-compose build --no-cache
```

## Kubernetes

### Core Concepts

```yaml
# pod.yaml - Pod (minimal unit)
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  labels:
    app: my-app
    tier: backend
spec:
  containers:
  - name: web
    image: myapp:latest
    ports:
    - containerPort: 8080
    env:
    - name: NODE_ENV
      value: "production"
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
```

```yaml
# deployment.yaml - Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: web
        image: myapp:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: my-app-secrets
              key: database-url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

```yaml
# service.yaml - Service
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: ClusterIP  # ClusterIP, NodePort, LoadBalancer
  selector:
    app: my-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

```yaml
# ingress.yaml - Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myapp.example.com
    secretName: myapp-tls
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

### ConfigMaps and Secrets

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-app-config
data:
  DATABASE_HOST: "postgres-service"
  REDIS_HOST: "redis-service"
  LOG_LEVEL: "info"
```

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-app-secrets
type: Opaque
stringData:
  database-url: "postgresql://user:pass@postgres:5432/mydb"
  api-key: "your-api-key-here"
```

### Persistent Storage

```yaml
# persistentvolumeclaim.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard
```

```yaml
# deployment with PVC
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        env:
        - name: POSTGRES_DB
          value: mydb
        - name: POSTGRES_USER
          value: user
        - name: POSTGRES_PASSWORD
          value: pass
        volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-data
        persistentVolumeClaim:
          claimName: postgres-pvc
```

### Helm Charts

```bash
# Install Helm
brew install helm

# Create new chart
helm create my-app

# Install chart
helm install my-release ./my-app

# Update
helm upgrade my-release ./my-app

# Rollback
helm rollback my-release 1

# Uninstall
helm uninstall my-release
```

```yaml
# values.yaml
replicaCount: 3

image:
  repository: myapp
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
  targetPort: 8080

ingress:
  enabled: true
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70

postgresql:
  enabled: true
  auth:
    database: mydb
    username: user
    password: pass

redis:
  enabled: true
  password: pass
```

### HPA (Horizontal Pod Autoscaler)

```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### Jobs and CronJobs

```yaml
# job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-migration
spec:
  ttlSecondsAfterFinished: 100
  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: migrate
        image: myapp:latest
        command: ["node", "migrate.js"]
```

```yaml
# cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-job
spec:
  schedule: "0 2 * * *"  # Every day at 2:00 AM
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: backup
            image: myapp:latest
            command: ["node", "backup.js"]
            env:
            - name: BACKUP_PATH
              value: "/backups"
```

## Kustomize

```yaml
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml

commonLabels:
  app: my-app

configMapGenerator:
  - name: my-app-config
    literals:
      - LOG_LEVEL=info
      - NODE_ENV=production

secretGenerator:
  - name: my-app-secrets
    envs:
      - .env.secrets

patchesStrategicMerge:
  - patch.yaml
```

## K9s (UI for Kubernetes)

```bash
# Install
brew install derailed/k9s/k9s

# Main commands
k9s                    # Run
:pod                   # View pods
:deploy                # View deployments
:svc                   # View services
:ingress               # View ingress
:secret                # View secrets
ctrl+d                 # Delete resource
ctrl+z                 # Edit
l                      # Logs
e                      # Logs (real-time)
y                      # YAML of resource
```

## Best Practices

### Docker
1. **Minimal images** - use alpine
2. **Multi-stage builds** - for size optimization
3. **Don't run as root** - USER in Dockerfile
4. **Health checks** - for monitoring
5. **.dockerignore** - exclude unnecessary
6. **Organize layers** - from frequent to rare
7. **Tag images** - don't use latest
8. **Scan for vulnerabilities** - trivy, snyk

### Kubernetes
1. **Resource limits** - always set
2. **Liveness/Readiness probes** - for reliability
3. **Secrets** - don't store in code
4. **HPA** - for scaling
5. **Pod Disruption Budgets** - for updates
6. **Network Policies** - isolation
7. **Ingress TLS** - always encrypt
8. **Backup etcd** - regularly

### Monitoring
1. **Prometheus + Grafana** - metrics
2. **EFK/ELK** - logging
3. **Jaeger/Zipkin** - tracing
