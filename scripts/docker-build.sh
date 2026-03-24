#!/bin/bash
# Docker build and push script for PaaS deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REGISTRY=${1:-docker.io}
NAMESPACE=${2:-lamtek}
VERSION=${3:-latest}

echo -e "${YELLOW}=== Starting PaaS Docker Build Process ===${NC}"

# Build Frontend
echo -e "${YELLOW}Building Frontend Docker image...${NC}"
docker build \
  -t "${REGISTRY}/${NAMESPACE}/frontend:${VERSION}" \
  -t "${REGISTRY}/${NAMESPACE}/frontend:latest" \
  -f ./frontend/Dockerfile \
  ./frontend

echo -e "${GREEN}✓ Frontend image built successfully${NC}"

# Build Backend
echo -e "${YELLOW}Building Backend Docker image...${NC}"
docker build \
  -t "${REGISTRY}/${NAMESPACE}/api-gateway:${VERSION}" \
  -t "${REGISTRY}/${NAMESPACE}/api-gateway:latest" \
  -f ./backend/Dockerfile \
  ./backend

echo -e "${GREEN}✓ Backend image built successfully${NC}"

# Build Blockchain (Hardhat)
echo -e "${YELLOW}Building Blockchain Docker image...${NC}"
docker build \
  -t "${REGISTRY}/${NAMESPACE}/blockchain:${VERSION}" \
  -t "${REGISTRY}/${NAMESPACE}/blockchain:latest" \
  -f ./blockchain/Dockerfile \
  ./blockchain

echo -e "${GREEN}✓ Blockchain image built successfully${NC}"

# Push to registry (optional)
if [ "$4" = "--push" ]; then
  echo -e "${YELLOW}Pushing images to registry...${NC}"
  
  docker push "${REGISTRY}/${NAMESPACE}/frontend:${VERSION}"
  docker push "${REGISTRY}/${NAMESPACE}/frontend:latest"
  echo -e "${GREEN}✓ Frontend image pushed${NC}"
  
  docker push "${REGISTRY}/${NAMESPACE}/api-gateway:${VERSION}"
  docker push "${REGISTRY}/${NAMESPACE}/api-gateway:latest"
  echo -e "${GREEN}✓ API Gateway image pushed${NC}"
  
  docker push "${REGISTRY}/${NAMESPACE}/blockchain:${VERSION}"
  docker push "${REGISTRY}/${NAMESPACE}/blockchain:latest"
  echo -e "${GREEN}✓ Blockchain image pushed${NC}"
else
  echo -e "${YELLOW}Skipping push. Use --push flag to push images to registry${NC}"
fi

echo -e "${GREEN}=== Docker Build Process Completed ===${NC}"
echo -e "\n${YELLOW}Built images:${NC}"
echo "  - ${REGISTRY}/${NAMESPACE}/frontend:${VERSION}"
echo "  - ${REGISTRY}/${NAMESPACE}/api-gateway:${VERSION}"
echo "  - ${REGISTRY}/${NAMESPACE}/blockchain:${VERSION}"

echo -e "\n${YELLOW}To deploy with Docker Compose:${NC}"
echo "  docker-compose -f docker-compose.prod.yml up -d"

echo -e "\n${YELLOW}To view logs:${NC}"
echo "  docker-compose -f docker-compose.prod.yml logs -f [service-name]"
