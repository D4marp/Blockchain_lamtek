#!/bin/bash

# ============================================
# LAMTEK COMPREHENSIVE TEST RUNNER
# ============================================

set -e

echo "🚀 LAMTEK BLOCKCHAIN SAAS - COMPREHENSIVE TEST SUITE"
echo "=================================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Function to run tests
run_test() {
    local name=$1
    local command=$2
    local dir=$3
    
    echo -e "${BLUE}[TEST] ${name}${NC}"
    echo "Command: ${command}"
    echo "---"
    
    cd "$dir" || exit
    
    if eval "$command"; then
        echo -e "${GREEN}✅ ${name} PASSED${NC}\n"
        ((PASSED++))
    else
        echo -e "${RED}❌ ${name} FAILED${NC}\n"
        ((FAILED++))
    fi
}

# Test 1: Backend Tests
echo -e "${YELLOW}Phase 1: Backend Tests${NC}"
run_test "Backend Unit Tests" "npm test" "./backend"

# Test 2: Blockchain Tests
echo -e "${YELLOW}Phase 2: Blockchain Smart Contract Tests${NC}"
run_test "Blockchain Tests" "npm test" "./blockchain"

# Test 3: Frontend Linting
echo -e "${YELLOW}Phase 3: Frontend Quality Checks${NC}"
run_test "Frontend Linting" "npm run lint" "./frontend"

# Test 4: Backend Coverage (optional)
echo -e "${YELLOW}Phase 4: Backend Code Coverage (Optional)${NC}"
if run_test "Backend Coverage" "npm run test:cov" "./backend" 2>/dev/null; then
    echo "Coverage report generated"
else
    echo "Coverage test skipped or unavailable"
fi

# Summary
echo ""
echo "============================================"
echo -e "${BLUE}TEST SUMMARY${NC}"
echo "============================================"
echo -e "✅ Passed: ${GREEN}${PASSED}${NC}"
echo -e "❌ Failed: ${RED}${FAILED}${NC}"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 ALL TESTS PASSED! 🎉${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run: docker-compose up -d"
    echo "  2. Visit: http://localhost:3002 (Frontend)"
    echo "  3. API Docs: http://localhost:3001/api/v1/docs"
    exit 0
else
    echo ""
    echo -e "${RED}⚠️  SOME TESTS FAILED ⚠️${NC}"
    exit 1
fi
