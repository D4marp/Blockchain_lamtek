#!/bin/bash
# ============================================
# LAM Teknik - Besu 4-Node Network Setup Script
# IBFT 2.0 Consensus with Kafka Integration
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================"
echo "LAM Teknik Blockchain Network Setup"
echo "4 Besu Validator Nodes + Kafka + IPFS"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    print_status "Docker is running"
}

# Create node directories
create_directories() {
    echo ""
    echo "Creating node directories..."
    
    for i in 1 2 3 4; do
        mkdir -p "node${i}/data"
        print_status "Created node${i}/data directory"
    done
}

# Generate node keys if they don't exist
generate_keys() {
    echo ""
    echo "Checking node keys..."
    
    # Node 1 key
    if [ ! -f "node1/key" ]; then
        echo "8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63" > node1/key
        print_status "Generated key for node1"
    else
        print_warning "Key for node1 already exists"
    fi
    
    # Node 2 key
    if [ ! -f "node2/key" ]; then
        echo "c87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3" > node2/key
        print_status "Generated key for node2"
    else
        print_warning "Key for node2 already exists"
    fi
    
    # Node 3 key
    if [ ! -f "node3/key" ]; then
        echo "ae6ae8e5ccbfb04590405997ee2d52d2b330726137b875053c36d94e974d162f" > node3/key
        print_status "Generated key for node3"
    else
        print_warning "Key for node3 already exists"
    fi
    
    # Node 4 key
    if [ ! -f "node4/key" ]; then
        echo "0dbbe8e4ae425a6d2687f1a7e3ba17bc98c673636790f1b8ad91193c05875ef1" > node4/key
        print_status "Generated key for node4"
    else
        print_warning "Key for node4 already exists"
    fi
}

# Clean old data
clean_data() {
    echo ""
    read -p "Do you want to clean old blockchain data? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for i in 1 2 3 4; do
            if [ -d "node${i}/data" ]; then
                rm -rf "node${i}/data/*"
                print_status "Cleaned node${i} data"
            fi
        done
    else
        print_warning "Keeping existing data"
    fi
}

# Display network info
show_network_info() {
    echo ""
    echo "============================================"
    echo "Network Configuration"
    echo "============================================"
    echo ""
    echo "Chain ID: 1337"
    echo "Consensus: IBFT 2.0"
    echo "Block Period: 2 seconds"
    echo ""
    echo "Validator Nodes:"
    echo "  - Node 1: http://localhost:8545 (Bootnode)"
    echo "  - Node 2: http://localhost:8555"
    echo "  - Node 3: http://localhost:8565"
    echo "  - Node 4: http://localhost:8575"
    echo ""
    echo "Kafka:"
    echo "  - Bootstrap: localhost:29092"
    echo "  - Kafka UI: http://localhost:8080"
    echo ""
    echo "IPFS:"
    echo "  - API: http://localhost:5001"
    echo "  - Gateway: http://localhost:8888"
    echo ""
    echo "Blockchain Explorer:"
    echo "  - BlockScout: http://localhost:4000"
    echo ""
}

# Main execution
main() {
    check_docker
    create_directories
    generate_keys
    
    if [ "$1" == "--clean" ]; then
        clean_data
    fi
    
    show_network_info
    
    echo "============================================"
    echo "Setup complete! Run the following to start:"
    echo ""
    echo "  cd $(dirname "$SCRIPT_DIR")"
    echo "  docker-compose up -d"
    echo ""
    echo "============================================"
}

main "$@"
