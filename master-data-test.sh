#!/bin/bash

# LAM Teknik - Automated Test Data Injection & Validation
# Script untuk test semua master-data endpoints dan inject data

set -e

API_BASE="http://localhost:3003/api/v1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
TOTAL=0
SUCCESS=0
FAILED=0
SKIPPED=0

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((SUCCESS++))
    ((TOTAL++))
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAILED++))
    ((TOTAL++))
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_skip() {
    echo -e "${CYAN}⊘ $1${NC}"
    ((SKIPPED++))
    ((TOTAL++))
}

log_header() {
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Check token
if [ -z "$1" ]; then
    echo -e "${RED}❌ Token not provided!${NC}"
    echo "Usage: $0 <JWT_TOKEN> [action]"
    echo ""
    echo "Actions:"
    echo "  test      - Test all endpoints (default)"
    echo "  inject    - Inject test data"
    echo "  validate  - Validate all data"
    echo ""
    echo "Example:"
    echo "  $0 'eyJhbGciOiJIUzI1NiIs...' test"
    exit 1
fi

TOKEN=$1
ACTION="${2:-test}"

# Check if backend is running
log_info "Checking backend connection..."
if curl -s -f -X GET "$API_BASE/health" > /dev/null 2>&1; then
    log_success "Backend is running"
else
    log_error "Cannot connect to backend at $API_BASE"
    exit 1
fi

# Test API call function
test_endpoint() {
    local test_name="$1"
    local method="$2"
    local endpoint="$3"
    local data="$4"
    local expected_status="$5"
    
    log_info "Testing: $test_name"
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_BASE$endpoint" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$API_BASE$endpoint" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$data" 2>/dev/null)
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [[ "$expected_status" == *"$http_code"* ]]; then
        log_success "$test_name (HTTP $http_code)"
        echo "$body"
        return 0
    else
        log_error "$test_name - Expected $expected_status, got $http_code"
        echo "Response: $body" | head -c 200
        echo ""
        return 1
    fi
}

# Test all endpoints
test_all() {
    log_header "TESTING ALL MASTER-DATA ENDPOINTS"
    
    # Test INSTITUSI
    log_info "Testing INSTITUSI endpoints..."
    
    test_endpoint "GET /master-data/institusi" "GET" "/master-data/institusi" "" "200"
    
    # Test valid POST
    institusi_data='{
        "kodeInstitusi": "TEST_'$(date +%s)'",
        "namaInstitusi": "Test Institut '$(date +%s)'",
        "jenisPt": "PTN",
        "status": "AKTIF",
        "alamat": "Jl. Test No. 1",
        "kota": "Jakarta",
        "email": "test@test.ac.id"
    }'
    
    test_endpoint "POST /master-data/institusi (valid)" "POST" "/master-data/institusi" "$institusi_data" "201"
    
    # Test invalid POST - missing required field
    invalid_data='{
        "kodeInstitusi": "TEST",
        "jenisPt": "PTN"
    }'
    test_endpoint "POST /master-data/institusi (missing namaInstitusi)" "POST" "/master-data/institusi" "$invalid_data" "400" || true
    
    # Test invalid enum
    invalid_enum='{
        "kodeInstitusi": "TEST",
        "namaInstitusi": "Test",
        "jenisPt": "INVALID"
    }'
    test_endpoint "POST /master-data/institusi (invalid enum)" "POST" "/master-data/institusi" "$invalid_enum" "400" || true
    
    # Test JENJANG
    log_info "Testing JENJANG endpoints..."
    test_endpoint "GET /master-data/jenjang" "GET" "/master-data/jenjang" "" "200"
    
    jenjang_data='{
        "kodeJenjang": "S1_'$(date +%s)'",
        "namaJenjang": "Strata 1"
    }'
    test_endpoint "POST /master-data/jenjang" "POST" "/master-data/jenjang" "$jenjang_data" "201"
    
    # Test PROVINSI
    log_info "Testing PROVINSI endpoints..."
    test_endpoint "GET /master-data/provinsi" "GET" "/master-data/provinsi" "" "200"
    
    provinsi_data='{
        "kodeProvinsi": "'$(date +%s)'",
        "namaProvinsi": "Test Provinsi"
    }'
    test_endpoint "POST /master-data/provinsi" "POST" "/master-data/provinsi" "$provinsi_data" "201"
    
    # Test KLASTER ILMU
    log_info "Testing KLASTER ILMU endpoints..."
    test_endpoint "GET /master-data/klaster-ilmu" "GET" "/master-data/klaster-ilmu" "" "200"
    
    klaster_data='{
        "kodeKlasterIlmu": "TEST_'$(date +%s)'",
        "namaKlasterIlmu": "Test Klaster Ilmu"
    }'
    test_endpoint "POST /master-data/klaster-ilmu" "POST" "/master-data/klaster-ilmu" "$klaster_data" "201"
    
    # Test STATUS INSTITUSI
    log_info "Testing STATUS INSTITUSI endpoints..."
    test_endpoint "GET /master-data/status-institusi" "GET" "/master-data/status-institusi" "" "200"
    
    status_data='{
        "kodeStatus": "TEST_'$(date +%s)'",
        "namaStatus": "Test Status"
    }'
    test_endpoint "POST /master-data/status-institusi" "POST" "/master-data/status-institusi" "$status_data" "201"
    
    # Test AUTH
    log_info "Testing AUTH endpoints..."
    test_endpoint "GET /auth/me" "GET" "/auth/me" "" "200"
}

# Inject test data
inject_data() {
    log_header "INJECTING TEST DATA"
    
    log_info "Creating provinces..."
    provinces=(
        '{"kodeProvinsi":"01","namaProvinsi":"Aceh"}'
        '{"kodeProvinsi":"02","namaProvinsi":"Sumatera Utara"}'
        '{"kodeProvinsi":"03","namaProvinsi":"Sumatera Barat"}'
        '{"kodeProvinsi":"04","namaProvinsi":"Riau"}'
        '{"kodeProvinsi":"05","namaProvinsi":"Jambi"}'
        '{"kodeProvinsi":"06","namaProvinsi":"Sumatera Selatan"}'
        '{"kodeProvinsi":"07","namaProvinsi":"Bengkulu"}'
        '{"kodeProvinsi":"08","namaProvinsi":"Lampung"}'
        '{"kodeProvinsi":"09","namaProvinsi":"Bangka Belitung"}'
        '{"kodeProvinsi":"10","namaProvinsi":"Riau Islands"}'
        '{"kodeProvinsi":"11","namaProvinsi":"Jakarta"}'
        '{"kodeProvinsi":"12","namaProvinsi":"West Java"}'
        '{"kodeProvinsi":"13","namaProvinsi":"Central Java"}'
    )
    
    for province in "${provinces[@]}"; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/master-data/provinsi" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$province" 2>/dev/null)
        
        http_code=$(echo "$response" | tail -n1)
        if [[ "$http_code" == "201" ]] || [[ "$http_code" == "409" ]]; then
            log_success "Province created/exists: $(echo $province | jq -r '.namaProvinsi')"
        else
            log_error "Failed to create province: $(echo $response | sed '$d')"
        fi
    done
    
    log_info "Creating institutions..."
    institutions=(
        '{"kodeInstitusi":"ITB","namaInstitusi":"Institut Teknologi Bandung","jenisPt":"PTN","status":"AKTIF","kota":"Bandung","email":"info@itb.ac.id"}'
        '{"kodeInstitusi":"UI","namaInstitusi":"Universitas Indonesia","jenisPt":"PTN","status":"AKTIF","kota":"Jakarta","email":"info@ui.ac.id"}'
        '{"kodeInstitusi":"UGM","namaInstitusi":"Universitas Gadjah Mada","jenisPt":"PTN","status":"AKTIF","kota":"Yogyakarta","email":"info@ugm.ac.id"}'
        '{"kodeInstitusi":"UNAIR","namaInstitusi":"Universitas Airlangga","jenisPt":"PTN","status":"AKTIF","kota":"Surabaya","email":"info@unair.ac.id"}'
        '{"kodeInstitusi":"UNPAD","namaInstitusi":"Universitas Padjadjaran","jenisPt":"PTN","status":"AKTIF","kota":"Bandung","email":"info@unpad.ac.id"}'
        '{"kodeInstitusi":"IPBB","namaInstitusi":"Institut Pertanian Bogor","jenisPt":"PTN","status":"AKTIF","kota":"Bogor","email":"info@ipb.ac.id"}'
    )
    
    for institution in "${institutions[@]}"; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/master-data/institusi" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$institution" 2>/dev/null)
        
        http_code=$(echo "$response" | tail -n1)
        if [[ "$http_code" == "201" ]] || [[ "$http_code" == "409" ]]; then
            log_success "Institution created/exists: $(echo $institution | jq -r '.namaInstitusi')"
        else
            log_error "Failed to create institution: $(echo $response | sed '$d' | jq . 2>/dev/null || echo 'Invalid JSON')"
        fi
    done
    
    log_info "Creating academic levels..."
    jenjang_list=(
        '{"kodeJenjang":"S1","namaJenjang":"Strata 1"}'
        '{"kodeJenjang":"S2","namaJenjang":"Strata 2"}'
        '{"kodeJenjang":"S3","namaJenjang":"Strata 3"}'
        '{"kodeJenjang":"D3","namaJenjang":"Diploma 3"}'
        '{"kodeJenjang":"D4","namaJenjang":"Diploma 4"}'
    )
    
    for jenjang in "${jenjang_list[@]}"; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/master-data/jenjang" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$jenjang" 2>/dev/null)
        
        http_code=$(echo "$response" | tail -n1)
        if [[ "$http_code" == "201" ]] || [[ "$http_code" == "409" ]]; then
            log_success "Jenjang created/exists: $(echo $jenjang | jq -r '.namaJenjang')"
        else
            log_error "Failed to create jenjang: $(echo $response | sed '$d')"
        fi
    done
}

# Validate data
validate_data() {
    log_header "VALIDATING INJECTED DATA"
    
    log_info "Fetching institutions..."
    response=$(curl -s -X GET "$API_BASE/master-data/institusi?take=100" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" 2>/dev/null)
    
    count=$(echo "$response" | jq '.total // 0')
    log_success "Found $count institutions"
    
    echo "$response" | jq '.data[] | {id, kodeInstitusi, namaInstitusi, status}' 2>/dev/null || true
    
    log_info "Fetching provinces..."
    response=$(curl -s -X GET "$API_BASE/master-data/provinsi?take=100" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" 2>/dev/null)
    
    count=$(echo "$response" | jq '.total // 0')
    log_success "Found $count provinces"
    
    log_info "Fetching academic levels..."
    response=$(curl -s -X GET "$API_BASE/master-data/jenjang?take=100" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" 2>/dev/null)
    
    count=$(echo "$response" | jq '.total // 0')
    log_success "Found $count academic levels"
}

# Main execution
case "$ACTION" in
    test)
        test_all
        ;;
    inject)
        inject_data
        ;;
    validate)
        validate_data
        ;;
    all)
        test_all
        inject_data
        validate_data
        ;;
    *)
        log_error "Unknown action: $ACTION"
        exit 1
        ;;
esac

# Print summary
log_header "TEST SUMMARY"
echo "Total Tests:    $TOTAL"
echo -e "Passed:         ${GREEN}$SUCCESS${NC}"
echo -e "Failed:         ${RED}$FAILED${NC}"
echo -e "Skipped:        ${CYAN}$SKIPPED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    log_success "All tests passed!"
    exit 0
else
    log_error "$FAILED tests failed"
    exit 1
fi
