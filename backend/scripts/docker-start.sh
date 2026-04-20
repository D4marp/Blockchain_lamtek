#!/bin/bash

# Docker Startup Script - Runs migrations and starts the API

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
  echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[$(date +'%H:%M:%S')] ✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}[$(date +'%H:%M:%S')] ⚠️  $1${NC}"
}

# Configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USERNAME="${DB_USERNAME:-lamtek}"
DB_PASSWORD="${DB_PASSWORD:-lamtek123}"
DB_DATABASE="${DB_DATABASE:-lamtek_db}"
PORT="${PORT:-3000}"
SEED_ON_STARTUP="${SEED_ON_STARTUP:-true}"

echo "============================================"
echo "🚀 LAM Teknik API Startup"
echo "============================================"
echo ""
echo "Config: $DB_USERNAME@$DB_HOST:$DB_PORT/$DB_DATABASE"
echo ""

# Wait for database
print_status "Waiting for database..."
RETRY=0

while [ $RETRY -lt 30 ]; do
  if npm run typeorm -- query "SELECT 1" 2>/dev/null; then
    print_success "Database ready"
    break
  fi
  RETRY=$((RETRY + 1))
  sleep 2
done

if [ $RETRY -eq 30 ]; then
  echo ""
  print_warning "Database did not become ready in time"
  exit 1
fi

echo ""

# Run migrations
print_status "Running migrations..."
npm run migration:run 2>&1

echo ""

# Run seeds
if [ "$SEED_ON_STARTUP" = "true" ]; then
  print_status "Seeding database..."
  npm run seed 2>&1 || print_warning "Seeds skipped"
else
  print_status "Seeding disabled (SEED_ON_STARTUP=$SEED_ON_STARTUP)"
fi

echo ""
print_success "Ready to start API"
echo ""

# Start the application
exec node dist/main