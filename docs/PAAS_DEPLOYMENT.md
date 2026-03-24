# PaaS Deployment Guide - Lamtek SaaS Blockchain

## Overview
Panduan ini menjelaskan cara mendeploy aplikasi Lamtek SaaS Blockchain ke berbagai platform PaaS dengan menggunakan Docker.

## Prasyarat
- Docker dan Docker Compose terinstal
- Git untuk version control
- Akses ke PaaS provider (Heroku, AWS, Google Cloud, Azure, dll)

---

## 1. Local Development Deployment

### 1.1 Menggunakan Docker Compose (Development)
```bash
# Import environment variables
export $(cat .env.paas | grep -v '^#' | xargs)

# Start all services
docker-compose -f docker-compose.yml up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 1.2 Menggunakan Docker Compose (Production)
```bash
# Start all services untuk production
docker-compose -f docker-compose.prod.yml up -d

# Check health status
docker-compose -f docker-compose.prod.yml ps

# View specific service logs
docker-compose -f docker-compose.prod.yml logs -f api-gateway
```

---

## 2. Building Docker Images

### 2.1 Build semua images secara otomatis
```bash
# Jalankan build script
cd scripts
chmod +x docker-build.sh
./docker-build.sh <registry> <namespace> <version> [--push]

# Contoh:
./docker-build.sh docker.io myorg 1.0.0 --push
```

### 2.2 Build individual images
```bash
# Frontend
docker build -t lamtek/frontend:latest -f ./frontend/Dockerfile ./frontend

# Backend
docker build -t lamtek/api-gateway:latest -f ./backend/Dockerfile ./backend

# Blockchain
docker build -t lamtek/blockchain:latest -f ./blockchain/Dockerfile ./blockchain
```

---

## 3. Deployment ke berbagai PaaS Platform

### 3.1 Heroku Deployment

#### Setup Heroku
```bash
# Install Heroku CLI
brew tap heroku/brew && brew install heroku

# Login ke Heroku
heroku login

# Create Heroku app
heroku create lamtek-saas

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your-secret-key
```

#### Deploy dengan Docker
```bash
# Login ke Heroku Container Registry
heroku container:login

# Push images
heroku container:push web -a lamtek-saas

# Release
heroku container:release web -a lamtek-saas

# View logs
heroku logs --tail -a lamtek-saas
```

### 3.2 AWS (ECS/Fargate) Deployment

#### Setup AWS CLI
```bash
# Install AWS CLI
brew install awscli

# Configure credentials
aws configure
```

#### Push ke ECR
```bash
# Create ECR repository
aws ecr create-repository --repository-name lamtek/frontend
aws ecr create-repository --repository-name lamtek/api-gateway
aws ecr create-repository --repository-name lamtek/blockchain

# Get ECR login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Tag dan push images
docker tag lamtek/frontend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/lamtek/frontend:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/lamtek/frontend:latest

# Repeat untuk Backend dan Blockchain...
```

#### Deploy dengan ECS
```bash
# Create ECS cluster
aws ecs create-cluster --cluster-name lamtek-cluster

# Register task definition
aws ecs register-task-definition --cli-input-json file://ecs-task-definition.json

# Create ECS service
aws ecs create-service \
  --cluster lamtek-cluster \
  --service-name lamtek-service \
  --task-definition lamtek-task:1 \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx]}"
```

### 3.3 Google Cloud Run Deployment

#### Setup Google Cloud
```bash
# Install Google Cloud SDK
brew install --cask google-cloud-sdk

# Authenticate
gcloud auth login

# Set project
gcloud config set project my-project-id
```

#### Deploy Frontend
```bash
# Build dan push ke Google Container Registry
gcloud builds submit --tag gcr.io/my-project-id/lamtek-frontend ./frontend

# Deploy to Cloud Run
gcloud run deploy lamtek-frontend \
  --image gcr.io/my-project-id/lamtek-frontend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars NODE_ENV=production
```

#### Deploy Backend
```bash
# Build dan push
gcloud builds submit --tag gcr.io/my-project-id/lamtek-api-gateway ./backend

# Deploy to Cloud Run
gcloud run deploy lamtek-api-gateway \
  --image gcr.io/my-project-id/lamtek-api-gateway \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars NODE_ENV=production,DATABASE_URL=<database-url>
```

### 3.4 Azure Container Instances Deployment

#### Setup Azure CLI
```bash
# Install Azure CLI
brew install azure-cli

# Login
az login
```

#### Deploy dengan Azure Container Instances
```bash
# Create resource group
az group create --name lamtek-rg --location eastus

# Create container registry
az acr create --resource-group lamtek-rg --name lamtekregistry --sku Basic

# Login ke ACR
az acr login --name lamtekregistry

# Build dan push images
az acr build --registry lamtekregistry --image lamtek/frontend:latest ./frontend
az acr build --registry lamtekregistry --image lamtek/api-gateway:latest ./backend

# Deploy container
az container create \
  --resource-group lamtek-rg \
  --name lamtek-frontend \
  --image lamtekregistry.azurecr.io/lamtek/frontend:latest \
  --cpu 1 --memory 1 \
  --registry-login-server lamtekregistry.azurecr.io \
  --registry-username <username> \
  --registry-password <password> \
  --ports 80 \
  --environment-variables NODE_ENV=production
```

---

## 4. Kubernetes Deployment (GKE/AKS/EKS)

### 4.1 Deploy dengan kubectl
```bash
# Apply configuration
kubectl apply -f k8s/deployment.yaml

# Check deployment status
kubectl get deployments
kubectl get services
kubectl get pods

# View logs
kubectl logs -f deployment/api-gateway

# Port forward untuk testing
kubectl port-forward svc/frontend 3002:80
kubectl port-forward svc/api-gateway 3001:3000
```

### 4.2 Update deployment
```bash
# Update image
kubectl set image deployment/api-gateway api-gateway=lamtek/api-gateway:v1.1.0

# Check rollout status
kubectl rollout status deployment/api-gateway

# Rollback jika diperlukan
kubectl rollout undo deployment/api-gateway
```

---

## 5. Environment Variables untuk PaaS

### 5.1 Frontend Environment
```bash
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://api.example.com
```

### 5.2 Backend Environment
```bash
NODE_ENV=production
PORT=3000
DATABASE_URL=mysql://user:pass@host:3306/dbname
JWT_SECRET=your-secret-key
BESU_RPC_URL=https://blockchain-rpc.example.com
REDIS_URL=redis://host:6379
KAFKA_BROKERS=kafka-broker:9092
```

---

## 6. Database Migrations pada PaaS

```bash
# Connect ke kontainer
docker exec -it lamtek-api-gateway bash

# Run migrations
npm run migration:run

# Create migration
npm run typeorm migration:create -- -n CreateUsersTable
```

---

## 7. Monitoring dan Logging

### 7.1 Docker Containers
```bash
# View running containers
docker ps

# View container stats
docker stats

# View container logs
docker logs -f container-name

# Check container health
docker inspect --format='{{json .State.Health}}' container-name
```

### 7.2 Kubernetes
```bash
# View pod logs
kubectl logs -f pod-name

# View pod events
kubectl describe pod pod-name

# Monitor resource usage
kubectl top nodes
kubectl top pods
```

---

## 8. Production Checklist

- [ ] Semua environment variables dikonfigurasi dengan benar
- [ ] Database backups dijadwalkan
- [ ] Monitoring dan alerting dikonfigurasi
- [ ] SSL/TLS certificates terinstall
- [ ] Rate limiting dikonfigurasi
- [ ] CORS policy dikonfigurasi dengan benar
- [ ] Logging dan centralized logging setup
- [ ] Security headers dikonfigurasi
- [ ] Health checks berfungsi dengan baik
- [ ] Auto-scaling policies dikonfigurasi

---

## 9. Troubleshooting

### Container tidak start
```bash
# Check logs
docker logs container-name

# Verify health
docker inspect container-name

# Rebuild container
docker build --no-cache -t lamtek/app:latest .
```

### Database connection error
```bash
# Check network connectivity
docker exec container-name curl -v mysql:3306

# Verify DATABASE_URL
docker exec container-name echo $DATABASE_URL
```

### Port already in use
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>
```

---

## Support & Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Project Repository](https://github.com/D4marp/Blockchain_lamtek)
