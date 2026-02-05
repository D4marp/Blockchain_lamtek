#!/bin/bash

# LAM Teknik - Complete Setup & Test Script
# This script starts the application and tests the authentication system

set -e

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   LAM Teknik SaaS - Authentication System Complete Setup      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running with --dev flag
DEV_MODE=false
if [ "$1" = "--dev" ]; then
    DEV_MODE=true
    echo -e "${YELLOW}🔧 Development Mode: Running in foreground${NC}"
    echo ""
fi

# Function to print section
print_section() {
    echo -e "${BLUE}▶ $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Check prerequisites
print_section "Checking Prerequisites..."

if ! command -v mysql &> /dev/null; then
    print_error "MySQL client not found. Please install mysql-client"
    exit 1
fi

if ! command -v node &> /dev/null; then
    print_error "Node.js not found. Please install Node.js"
    exit 1
fi

print_success "Prerequisites OK"
echo ""

# Step 2: Test database
print_section "Testing Database Connection..."

if mysql -u lamtek -plamtek123 lamtek_db -e "SELECT 1;" &>/dev/null; then
    print_success "Database connection OK"
else
    print_error "Cannot connect to database. Check credentials in backend/.env"
    echo "Expected: mysql://lamtek:lamtek123@localhost:3306/lamtek_db"
    exit 1
fi
echo ""

# Step 3: Install dependencies
if [ ! -d "$BACKEND_DIR/node_modules" ]; then
    print_section "Installing backend dependencies..."
    cd "$BACKEND_DIR"
    npm install
    print_success "Backend dependencies installed"
    echo ""
fi

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
    print_section "Installing frontend dependencies..."
    cd "$FRONTEND_DIR"
    npm install
    print_success "Frontend dependencies installed"
    echo ""
fi

# Step 4: Seed database
print_section "Seeding database with test users..."
cd "$BACKEND_DIR"
npm run seed
echo ""

# Step 5: Start backend
print_section "Starting backend server..."
cd "$BACKEND_DIR"

if [ "$DEV_MODE" = true ]; then
    echo -e "${YELLOW}Running backend in foreground. Press Ctrl+C to stop.${NC}"
    npm run dev
else
    npm run dev > /tmp/lamtek-backend.log 2>&1 &
    BACKEND_PID=$!
    sleep 5
    
    if ps -p $BACKEND_PID > /dev/null; then
        print_success "Backend started (PID: $BACKEND_PID)"
        echo "   Logs: tail -f /tmp/lamtek-backend.log"
    else
        print_error "Backend failed to start"
        echo "   Check logs: cat /tmp/lamtek-backend.log"
        exit 1
    fi
fi

echo ""

# Step 6: Start frontend
print_section "Starting frontend server..."
cd "$FRONTEND_DIR"

if [ "$DEV_MODE" = true ]; then
    echo -e "${YELLOW}Running frontend in foreground. Press Ctrl+C to stop.${NC}"
    npm run dev
else
    npm run dev > /tmp/lamtek-frontend.log 2>&1 &
    FRONTEND_PID=$!
    sleep 5
    
    if ps -p $FRONTEND_PID > /dev/null; then
        print_success "Frontend started (PID: $FRONTEND_PID)"
        echo "   Logs: tail -f /tmp/lamtek-frontend.log"
    else
        print_error "Frontend failed to start"
        echo "   Check logs: cat /tmp/lamtek-frontend.log"
        exit 1
    fi
fi

if [ "$DEV_MODE" = false ]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    🎉 Setup Complete! 🎉                      ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    
    echo -e "${BLUE}📍 Access the Application:${NC}"
    echo "   Login:     ${GREEN}http://localhost:3000/login${NC}"
    echo "   Dashboard: ${GREEN}http://localhost:3000/dashboard${NC}"
    echo "   API Docs:  ${GREEN}http://localhost:3003/api/docs${NC}"
    echo ""
    
    echo -e "${BLUE}🔑 Test Credentials:${NC}"
    echo "   Email:    admin@lamtek.ac.id"
    echo "   Password: password123"
    echo "   Role:     ADMIN"
    echo ""
    
    echo -e "${BLUE}📚 Additional Test Users:${NC}"
    echo "   • demo@test.com (PRODI)"
    echo "   • validator@test.com (VALIDATOR)"
    echo "   • institution@test.com (KOMITE_EVALUASI)"
    echo ""
    
    echo -e "${BLUE}📖 Documentation:${NC}"
    echo "   • AUTH_SETUP_COMPLETE.md - Full setup & testing guide"
    echo "   • DATABASE_FIXES.md - Database fixes applied"
    echo "   • FRONTEND_INTEGRATION_GUIDE.md - Frontend details"
    echo "   • RUNNING_GUIDE.md - How to run the app"
    echo ""
    
    echo -e "${BLUE}🛑 To Stop Servers:${NC}"
    echo "   pkill -f 'npm run dev'"
    echo ""
    
    echo -e "${YELLOW}⏳ Checking API health...${NC}"
    sleep 2
    
    if curl -s http://localhost:3003/api/v1/health > /dev/null 2>&1; then
        print_success "Backend API is responding"
    else
        echo -e "${YELLOW}⚠️  Backend still starting, wait a moment...${NC}"
    fi
    
    echo ""
    echo "✨ Ready to test! Open your browser and enjoy! ✨"
    echo ""
fi
