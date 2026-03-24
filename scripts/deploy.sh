#!/bin/bash
# Deploy script for PaaS platforms

set -e

ENVIRONMENT=${1:-development}
COMPOSE_FILE="docker-compose.prod.yml"

if [ "$ENVIRONMENT" = "development" ]; then
  COMPOSE_FILE="docker-compose.yml"
fi

echo "========================================="
echo "  Deploying to $ENVIRONMENT environment"
echo "========================================="

# Load environment variables
if [ -f ".env.paas" ]; then
  echo "Loading environment variables from .env.paas..."
  export $(cat .env.paas | grep -v '^#' | xargs)
fi

# Pull latest images (if not building locally)
echo "Pulling latest service images..."
docker-compose -f "$COMPOSE_FILE" pull || true

# Build images
echo "Building Docker images..."
docker-compose -f "$COMPOSE_FILE" build --parallel

# Start services
echo "Starting services..."
docker-compose -f "$COMPOSE_FILE" up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 10

# Check health status
echo "Checking service health..."
docker-compose -f "$COMPOSE_FILE" ps

echo ""
echo "========================================="
echo "  Deployment completed successfully!"
echo "========================================="
echo ""
echo "Services available at:"
echo "  Frontend: http://localhost:3002"
echo "  API Gateway: http://localhost:3001"
echo "  Redis: localhost:6379"
echo "  Kafka: localhost:9092"
echo "  MySQL: localhost:3306"
echo "  Besu RPC: http://localhost:8545"
echo "  IPFS API: http://localhost:5001"
echo ""
echo "To view logs: docker-compose -f $COMPOSE_FILE logs -f"
echo "To stop services: docker-compose -f $COMPOSE_FILE down"
