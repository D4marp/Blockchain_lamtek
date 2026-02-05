#!/bin/bash

# LAM Teknik - Quick Start for Akreditasi Data Injection
# Script untuk cepat mendapatkan token dan inject data akreditasi

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║     LAM TEKNIK - Akreditasi Data Injection             ║"
    echo "║     Quick Start Script                                 ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

show_menu() {
    echo ""
    echo -e "${MAGENTA}========== PILIH AKSI ==========${NC}"
    echo "1. Login dan dapatkan token baru"
    echo "2. Inject data akreditasi reguler (dengan token manual)"
    echo "3. Login + Inject data (recommended)"
    echo "4. Lihat panduan lengkap"
    echo "5. Keluar"
    echo -e "${MAGENTA}=============================${NC}"
    echo ""
    read -p "Pilihan (1-5): " choice
}

# Function: Login
login() {
    echo ""
    read -p "Email (default: admin@lamtek.com): " email
    email=${email:-admin@lamtek.com}
    
    read -sp "Password (default: password123): " password
    password=${password:-password123}
    echo ""
    
    log_info "Melakukan login ke API..."
    
    response=$(curl -s -X POST "http://localhost:3003/api/v1/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}")
    
    token=$(echo "$response" | jq -r '.access_token // empty' 2>/dev/null)
    
    if [ -z "$token" ]; then
        log_error "Login gagal!"
        echo "Response: $response"
        return 1
    fi
    
    log_success "Login berhasil!"
    echo ""
    echo "Token:"
    echo -e "${YELLOW}$token${NC}"
    echo ""
    
    return 0
}

# Function: Inject dengan token
inject_with_token() {
    echo ""
    read -p "Masukkan JWT token: " token
    
    if [ -z "$token" ]; then
        log_error "Token kosong!"
        return 1
    fi
    
    log_info "Menjalankan injection script..."
    bash "$SCRIPT_DIR/inject-akreditasi-reguler.sh" "$token"
}

# Function: Login + Inject
login_and_inject() {
    if login; then
        read -p "Gunakan token ini untuk inject? (y/n): " confirm
        if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
            log_info "Menjalankan injection script..."
            bash "$SCRIPT_DIR/inject-akreditasi-reguler.sh" "$token"
        fi
    fi
}

# Function: Show Guide
show_guide() {
    if [ -f "$SCRIPT_DIR/AKREDITASI_REGULER_GUIDE.md" ]; then
        less "$SCRIPT_DIR/AKREDITASI_REGULER_GUIDE.md"
    else
        log_error "File panduan tidak ditemukan"
    fi
}

# Main Loop
show_banner

# Check prerequisites
log_info "Memeriksa prerequisites..."

# Check jq
if ! command -v jq &> /dev/null; then
    log_error "jq tidak ditemukan. Install dengan: brew install jq"
    exit 1
fi

# Check curl
if ! command -v curl &> /dev/null; then
    log_error "curl tidak ditemukan"
    exit 1
fi

# Check backend
if ! curl -s http://localhost:3003/api/v1/health &> /dev/null; then
    log_error "Backend tidak berjalan di http://localhost:3003"
    echo "Pastikan docker containers running:"
    echo "  docker-compose up -d"
    exit 1
fi

log_success "Backend berjalan ✓"
log_success "curl installed ✓"
log_success "jq installed ✓"

# Main menu loop
while true; do
    show_menu
    
    case $choice in
        1)
            log_info "=== LOGIN ==="
            login
            ;;
        2)
            log_info "=== INJECT DENGAN TOKEN MANUAL ==="
            inject_with_token
            ;;
        3)
            log_info "=== LOGIN & INJECT ==="
            login_and_inject
            ;;
        4)
            show_guide
            ;;
        5)
            log_success "Terima kasih! Sampai jumpa."
            exit 0
            ;;
        *)
            log_error "Pilihan tidak valid"
            ;;
    esac
    
    read -p "Press enter untuk lanjut..."
done
