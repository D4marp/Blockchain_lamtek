#!/bin/bash

# ===========================================
# LAM Teknik SaaS Blockchain - Setup Script
# ===========================================

set -e

echo "================================================"
echo "  LAM Teknik SaaS Blockchain Platform Setup"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check requirements
echo -e "${YELLOW}Checking requirements...${NC}"

command -v docker >/dev/null 2>&1 || { 
  echo -e "${RED}Docker is required but not installed. Please install Docker first.${NC}" 
  exit 1
}

command -v docker-compose >/dev/null 2>&1 || { 
  echo -e "${RED}Docker Compose is required but not installed. Please install Docker Compose first.${NC}" 
  exit 1
}

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"

# Create directories
echo -e "\n${YELLOW}Creating directories...${NC}"
mkdir -p blockchain/besu/node1/data
mkdir -p blockchain/besu/node2/data
mkdir -p database/mysql-data
mkdir -p database/redis-data
mkdir -p database/blockscout-data
mkdir -p ipfs/data
mkdir -p ipfs/staging

echo -e "${GREEN}✓ Directories created${NC}"

# Setup environment
echo -e "\n${YELLOW}Setting up environment...${NC}"
if [ ! -f backend/.env ]; then
  cp backend/.env.example backend/.env
  echo -e "${GREEN}✓ Created backend/.env from template${NC}"
else
  echo -e "${YELLOW}⚠ backend/.env already exists, skipping${NC}"
fi

# Make blockchain scripts executable
chmod +x blockchain/besu/setup-network.sh 2>/dev/null || true

echo -e "\n${YELLOW}Setting up Besu network keys...${NC}"
cd blockchain/besu && ./setup-network.sh && cd ../..

echo ""
echo "================================================"
echo -e "${GREEN}  Setup Complete!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Start all containers:"
echo "   ${YELLOW}docker-compose up -d${NC}"
echo ""
echo "2. Check container status:"
echo "   ${YELLOW}docker-compose ps${NC}"
echo ""
echo "3. View logs:"
echo "   ${YELLOW}docker-compose logs -f${NC}"
echo ""
echo "4. Access services:"
echo "   - API:        http://localhost:3000"
echo "   - Swagger:    http://localhost:3000/api/docs"
echo "   - Besu RPC:   http://localhost:8545"
echo "   - IPFS API:   http://localhost:5001"
echo "   - IPFS GW:    http://localhost:8080"
echo "   - Explorer:   http://localhost:4000"
echo ""
echo "5. Deploy smart contracts:"
echo "   ${YELLOW}cd blockchain && npm run deploy${NC}"
echo ""
