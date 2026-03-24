# Docker Configuration Guide - Lamtek SaaS Blockchain

## Overview
Panduan lengkap untuk mengkonfigurasi dan mengoptimalkan Docker images untuk production deployment.

---

## 1. Multi-Stage Build Architecture

### 1.1 Frontend Docker Build Process
```dockerfile
# Stage 1: Builder
- Install semua dependencies (dev + prod)
- Build Next.js application
- Generate optimized production build

# Stage 2: Runtime
- Copy hanya production dependencies
- Copy built application
- Setup security (non-root user)
- Configure healthcheck
```

**Manfaat:**
- Ukuran image 60% lebih kecil
- Lebih aman (tidak ada dev tools)
- Faster deployment

### 1.2 Backend Docker Build Process
```dockerfile
# Stage 1: Builder
- Install dependencies
- Rebuild bcrypt untuk Alpine Linux
- Build NestJS application dengan TypeScript

# Stage 2: Runtime
- Include hanya production dependencies
- Copy compiled JavaScript (dist/)
- Setup non-root user
- Configure healthcheck
```

---

## 2. Docker Image Optimization

### 2.1 Base Image Selection
```bash
# Frontend
node:20-alpine (Alpine Linux)
- Size: ~150MB vs 900MB (full)
- Security: Minimal attack surface
- Speed: Faster deployment

# Backend
node:20-alpine
- Lightweight
- Includes curl untuk healthcheck

# Blockchain
node:20-alpine
- Consistent dengan services lain
```

### 2.2 Layer Optimization
```dockerfile
# Good: Combine commands to reduce layers
RUN apk add --no-cache python3 make g++ && \
    npm ci && \
    npm rebuild bcrypt

# Bad: Separate RUN commands create layers
RUN apk add --no-cache python3
RUN apk add --no-cache make
RUN apk add --no-cache g++
RUN npm ci
```

### 2.3 Cache Busting
```dockerfile
# Place layer yang sering berubah di akhir
COPY package*.json ./    # Jarang berubah - cache digunakan
RUN npm ci
COPY src ./src           # Sering berubah - cache invalid
COPY dist ./dist
```

---

## 3. Docker Compose Configuration

### 3.1 Service Dependencies
```yaml
api-gateway:
  depends_on:
    mysql:
      condition: service_healthy    # Wait until healthy
    redis:
      condition: service_healthy
    kafka:
      condition: service_healthy
```

### 3.2 Health Checks
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 30s      # Check every 30 seconds
  timeout: 10s       # Wait 10 seconds for response
  retries: 3         # Mark unhealthy after 3 failures
  start_period: 15s  # Grace period sebelum health check
```

### 3.3 Volume Management
```yaml
volumes:
  mysql-data:        # Named volume (persisted)
  redis-data:
  ipfs-data:
  
  # Untuk development (mount local folder)
  ./backend/src:/app/src:ro    # Read-only mount
```

---

## 4. Security Best Practices

### 4.1 Non-Root User
```dockerfile
# Create dan use non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs
```

**Manfaat:**
- Container escape lebih susah
- Prevent accidental root operations
- Best practice untuk production

### 4.2 Environment Variables
```bash
# Use secrets untuk sensitive data
docker run --env-file .env.prod ...

# Atau dengan Docker Secrets (Swarm)
docker secret create db_password -
```

### 4.3 Image Scanning
```bash
# Scan untuk vulnerabilities
docker scan lamtek/api-gateway:latest

# Atau dengan Trivy
trivy image lamtek/api-gateway:latest
```

---

## 5. Performance Optimization

### 5.1 CPU Limits
```yaml
resources:
  requests:
    cpu: "250m"        # Minimum guaranteed CPU
  limits:
    cpu: "500m"        # Maximum CPU available
```

### 5.2 Memory Limits
```yaml
resources:
  requests:
    memory: "256Mi"    # Minimum memory
  limits:
    memory: "512Mi"    # Maximum memory
```

### 5.3 Network Optimization
```yaml
networks:
  - lamtek-network     # Custom network untuk better isolation
```

---

## 6. Logging Strategy

### 6.1 Container Logging
```bash
# View logs
docker logs <container-id>

# Follow logs (streaming)
docker logs -f <container-id>

# Last 100 lines
docker logs --tail 100 <container-id>

# With timestamps
docker logs -t <container-id>
```

### 6.2 Centralized Logging
```yaml
# ELK Stack untuk production
api-gateway:
  logging:
    driver: splunk
    options:
      splunk-token: <token>
      splunk-url: https://logs.example.com
```

---

## 7. Deployment Commands

### 7.1 Build Images
```bash
# Build specific service
docker-compose build api-gateway

# Build all with no cache
docker-compose build --no-cache

# Build dengan custom tags
docker build -t lamtek/frontend:v1.0.0 ./frontend
```

### 7.2 Run Containers
```bash
# Start services
docker-compose up -d

# Start dengan build baru
docker-compose up -d --build

# Scale services
docker-compose up -d --scale api-gateway=3
```

### 7.3 Stop & Cleanup
```bash
# Stop services (keep volumes)
docker-compose stop

# Remove services (remove volumes)
docker-compose down -v

# Remove dangling images
docker image prune

# Remove all unused resources
docker system prune
```

---

## 8. Registry & Distribution

### 8.1 Docker Hub
```bash
# Login
docker login

# Tag image
docker tag lamtek/api-gateway:latest myuser/api-gateway:latest

# Push
docker push myuser/api-gateway:latest

# Pull
docker pull myuser/api-gateway:latest
```

### 8.2 Private Registry (e.g., Google Container Registry)
```bash
# Authenticate
gcloud auth configure-docker

# Tag for GCR
docker tag lamtek/api-gateway:latest gcr.io/my-project/api-gateway:latest

# Push to GCR
docker push gcr.io/my-project/api-gateway:latest
```

### 8.3 Registry Cleanup
```bash
# Delete image from registry
gcloud container images delete gcr.io/my-project/api-gateway:v1.0.0

# List images
docker images

# Remove local image
docker rmi lamtek/api-gateway:latest
```

---

## 9. Debugging Tips

### 9.1 Interactive Shell
```bash
# Access container shell
docker exec -it <container-id> /bin/sh

# Run command in container
docker exec <container-id> curl http://localhost:3000/health
```

### 9.2 Inspect Configuration
```bash
# View container config
docker inspect <container-id>

# View image layers
docker history <image-id>

# View disk usage
docker system df
```

### 9.3 Network Debugging
```bash
# Test connectivity between containers
docker exec <container-id> curl http://other-service:port

# Check network
docker network inspect lamtek-network
```

---

## 10. Production Checklist

### Before Deploying
- [ ] All Dockerfiles use multi-stage builds
- [ ] Base images pinned to specific versions
- [ ] Non-root user configured
- [ ] Health checks implemented
- [ ] Environment variables externalized
- [ ] Volumes properly configured
- [ ] Networks properly segmented
- [ ] Resource limits set
- [ ] Security scanning passed
- [ ] Logging configured

### During Deployment
- [ ] Pre-deployment backup created
- [ ] Load balancer updated
- [ ] DNS updated (if needed)
- [ ] SSL certificates configured
- [ ] Monitoring alerts enabled
- [ ] Logging aggregation working

### After Deployment
- [ ] All services healthy
- [ ] No error logs
- [ ] Performance metrics normal
- [ ] Database backups running
- [ ] Monitoring active
- [ ] Alerts configured

---

## Files Reference

| File | Purpose |
|------|---------|
| `frontend/Dockerfile` | Frontend Next.js container |
| `backend/Dockerfile` | Backend NestJS container |
| `blockchain/Dockerfile` | Blockchain Hardhat container |
| `docker-compose.yml` | Development environment |
| `docker-compose.prod.yml` | Production environment |
| `.env.paas` | PaaS environment variables |
| `scripts/docker-build.sh` | Automated build script |
| `scripts/deploy.sh` | Deployment script |
| `k8s/deployment.yaml` | Kubernetes manifests |

---

## References

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
- [Alpine Linux Guidelines](https://docs.docker.com/language/python/build-images/)
- [Container Security](https://docs.docker.com/engine/security/)
