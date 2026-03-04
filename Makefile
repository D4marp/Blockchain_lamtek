.PHONY: help install test lint format build deploy clean

help:
	@echo "================================================"
	@echo "  Blockchain Lamtek - Development Commands"
	@echo "================================================"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make install              - Install all dependencies"
	@echo "  make setup-dev             - Setup development environment"
	@echo ""
	@echo "Development:"
	@echo "  make dev                   - Start development environment"
	@echo "  make dev-stop              - Stop development environment"
	@echo ""
	@echo "Testing:"
	@echo "  make test                  - Run all tests"
	@echo "  make test-contracts        - Test smart contracts"
	@echo "  make test-backend          - Test backend API"
	@echo "  make test-integration      - Run integration tests"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint                  - Run linting"
	@echo "  make format                - Format code"
	@echo "  make analyze               - Analyze codebase"
	@echo "  make security              - Security audit"
	@echo ""
	@echo "Build & Deploy:"
	@echo "  make build                 - Build all components"
	@echo "  make build-contracts       - Compile smart contracts"
	@echo "  make build-backend         - Build backend"
	@echo "  make docker-build          - Build Docker images"
	@echo ""
	@echo "Smart Contracts:"
	@echo "  make deploy-local          - Deploy to local network"
	@echo "  make deploy-test           - Deploy to testnet"
	@echo "  make console               - Open Hardhat console"
	@echo ""
	@echo "Blockchain:"
	@echo "  make blockchain-start      - Start Besu nodes"
	@echo "  make blockchain-stop       - Stop Besu nodes"
	@echo "  make blockchain-logs       - View Besu logs"
	@echo "  make blockchain-reset      - Reset blockchain data"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean                 - Clean build artifacts"
	@echo "  make status                - Show service status"
	@echo ""

# Installation & Setup
install:
	@echo "Installing dependencies..."
	cd backend && npm install
	cd ../blockchain && npm install

setup-dev:
	@bash scripts/setup-dev-env.sh

# Development
dev:
	docker-compose up -d besu-node1 besu-node2 ipfs-node
	@echo "✓ Services started"
	@echo "  Besu RPC: http://localhost:8545"
	@echo "  IPFS API: http://localhost:5001"
	@echo "  IPFS Gateway: http://localhost:8888"

dev-stop:
	docker-compose down
	@echo "✓ Services stopped"

# Testing
test: test-contracts test-backend
	@echo "✓ All tests passed"

test-contracts:
	@echo "Testing smart contracts..."
	cd blockchain && npm test

test-backend:
	@echo "Testing backend API..."
	cd backend && npm test

test-integration:
	@echo "Running integration tests..."
	cd backend && npm run test:integration

test-coverage:
	@echo "Generating coverage reports..."
	cd blockchain && npm test -- --coverage
	cd ../backend && npm test -- --coverage

# Code Quality
lint:
	@echo "Linting code..."
	cd backend && npm run lint || true
	cd ../blockchain && npx hardhat compile --force || true

format:
	@echo "Formatting code..."
	npx prettier --write . --ignore-path .prettierignore

analyze:
	@bash scripts/code-quality.sh

security:
	@echo "Running security audit..."
	cd backend && npm audit --audit-level=moderate || true
	cd ../blockchain && npm audit || true

# Build
build: build-contracts build-backend
	@echo "✓ Build complete"

build-contracts:
	@echo "Compiling smart contracts..."
	cd blockchain && npx hardhat compile

build-backend:
	@echo "Building backend..."
	cd backend && npm run build

docker-build:
	@echo "Building Docker images..."
	docker-compose build

# Smart Contracts
deploy-local:
	@echo "Deploying to local network..."
	cd blockchain && npm run deploy:local

deploy-test:
	@echo "Deploying to testnet..."
	cd blockchain && npm run deploy

console:
	@echo "Opening Hardhat console..."
	cd blockchain && npx hardhat console --network localhost

# Blockchain
blockchain-start:
	docker-compose up -d besu-node1 besu-node2
	@echo "✓ Blockchain started"

blockchain-stop:
	docker-compose down besu-node1 besu-node2
	@echo "✓ Blockchain stopped"

blockchain-logs:
	docker-compose logs -f besu-node1

blockchain-status:
	@echo "Blockchain Health:"
	@curl -s http://localhost:8545 -X POST \
		-H "Content-Type: application/json" \
		-d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq .

blockchain-reset:
	@echo "⚠ WARNING: Resetting blockchain data!"
	@read -p "Continue? (y/N) " confirm && \
	[ "$$confirm" = "y" ] && \
	find blockchain/besu/node*/data -type f -delete && \
	docker-compose restart besu-node1 besu-node2 && \
	echo "✓ Blockchain reset" || \
	echo "Cancelled"

# Utilities
clean:
	@echo "Cleaning build artifacts..."
	rm -rf blockchain/artifacts blockchain/cache
	rm -rf backend/dist
	rm -rf coverage/
	@echo "✓ Clean complete"

status:
	@echo "Service Status:"
	@docker-compose ps

logs:
	@docker-compose logs -f

# Git Hooks
hooks-install:
	@bash scripts/setup-dev-env.sh

hooks-uninstall:
	@rm -rf .git/hooks/pre-commit .git/hooks/commit-msg
	@echo "✓ Git hooks removed"

# Quick Commands
rpc-test:
	@curl -X POST http://localhost:8545 \
		-H "Content-Type: application/json" \
		-d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

ipfs-test:
	@curl -X POST http://localhost:5001/api/v0/version

validate-env:
	@bash scripts/code-quality.sh

.DEFAULT_GOAL := help
