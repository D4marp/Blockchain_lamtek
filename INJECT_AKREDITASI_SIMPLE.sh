#!/bin/bash

# LAM Teknik - Simple Akreditasi Reguler Data Injection
# Works with existing Akreditasi API

API_BASE="http://localhost:3003/api/v1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

TOTAL=0
SUCCESS=0
FAILED=0

log_header() {
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════${NC}"
    echo ""
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

# Check token
if [ -z "$1" ]; then
    echo -e "${RED}❌ Token not provided!${NC}"
    echo ""
    echo "Usage: $0 <TOKEN>"
    echo ""
    echo "Cara mendapatkan token:"
    echo "  ./GET_TOKEN.sh"
    echo ""
    exit 1
fi

TOKEN=$1

log_header "INJECTING AKREDITASI REGULER DATA"

# Get institusi
log_header "Getting Institusi Data"
institusi_response=$(curl -s -X GET "$API_BASE/master-data/institusi?take=1" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null)

institusi_id=$(echo "$institusi_response" | jq -r '.[0].id // empty')
institusi_nama=$(echo "$institusi_response" | jq -r '.[0].namaInstitusi // empty')

if [ -z "$institusi_id" ]; then
    log_error "Institusi tidak ditemukan"
    exit 1
fi

log_success "Using Institusi: $institusi_nama (ID: $institusi_id)"

# Create Akreditasi Reguler applications with different stages
log_header "Creating Akreditasi Reguler Records"

for i in {1..3}; do
    echo ""
    echo -e "${BLUE}Creating Akreditasi $i...${NC}"
    
    # Create akreditasi
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/akreditasi" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"kodeAkreditasi\": \"AK_REG_$(printf '%03d' $i)_2024\",
            \"institusiId\": $institusi_id,
            \"prodiId\": null,
            \"tipe\": \"REGULER\",
            \"tahun\": 2024,
            \"status\": \"REGISTRASI\",
            \"peringkat\": \"BELUM_TERAKREDITASI\"
        }" 2>/dev/null)
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    akreditasi_id=$(echo "$body" | jq -r '.id // empty')
    
    if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
        log_success "Akreditasi $i created (ID: $akreditasi_id)"
        
        # Progress through stages
        stages=("VERIFIKASI_DOKUMEN" "PEMBAYARAN" "PENAWARAN_ASESOR" "ASESMEN_KECUKUPAN" "PENGESAHAN_AK" "ASESMEN_LAPANGAN" "TANGGAPAN_AL" "PENGESAHAN_AL" "PENETAPAN_PERINGKAT" "SINKRONISASI_BANPT" "SELESAI")
        
        for stage in "${stages[@]}"; do
            status_response=$(curl -s -w "\n%{http_code}" -X PUT "$API_BASE/akreditasi/$akreditasi_id/status" \
                -H "Authorization: Bearer $TOKEN" \
                -H "Content-Type: application/json" \
                -d "{\"status\": \"$stage\"}" 2>/dev/null)
            
            status_code=$(echo "$status_response" | tail -n1)
            
            if [[ "$status_code" == "200" ]]; then
                log_success "  └─ Updated to stage: $stage"
            fi
            
            sleep 0.2  # Small delay between requests
        done
    else
        log_error "Akreditasi $i creation failed (HTTP $http_code)"
        echo "$body" | jq . 2>/dev/null | head -20
    fi
done

log_header "INJECTION SUMMARY"

echo ""
echo "Summary:"
echo -e "  Total: $TOTAL"
echo -e "  Successful: ${GREEN}$SUCCESS${NC}"
echo -e "  Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    log_success "Semua data berhasil di-inject!"
    exit 0
else
    log_error "$FAILED records gagal"
    exit 1
fi
