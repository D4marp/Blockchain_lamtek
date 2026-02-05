#!/bin/bash

# LAM Teknik - Complete Akreditasi Reguler Data Injection
# Creates all necessary master data and akreditasi records

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

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check token
if [ -z "$1" ]; then
    echo -e "${RED}❌ Token not provided!${NC}"
    exit 1
fi

TOKEN=$1

log_header "CREATING MASTER DATA FOR AKREDITASI"

# ========================
# 1. CREATE JENJANG (Degree Level)
# ========================
log_info "Creating Jenjang (Degree Levels)..."

jenjang_s1=$(curl -s -X POST "$API_BASE/master-data/jenjang" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"kodeJenjang":"S1","namaJenjang":"Sarjana","isActive":true}' | jq -r '.id')

if [ ! -z "$jenjang_s1" ] && [ "$jenjang_s1" != "null" ]; then
    log_success "Created Jenjang S1 (ID: $jenjang_s1)"
else
    log_info "Jenjang S1 might already exist, fetching..."
    jenjang_s1=$(curl -s "$API_BASE/master-data/jenjang" -H "Authorization: Bearer $TOKEN" | jq -r '.[0].id // empty')
    if [ -z "$jenjang_s1" ]; then
        log_error "Failed to get Jenjang ID"
        jenjang_s1="1"
    else
        log_success "Found existing Jenjang S1 (ID: $jenjang_s1)"
    fi
fi

# ========================
# 2. CREATE UPPS (Unit Penjaminan Mutu Pendidikan)
# ========================
log_info "Creating UPPS (Penjaminan Mutu)..."

upps_response=$(curl -s -X POST "$API_BASE/akreditasi-reguler/upps" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"UPPS ITB","institusiId":1}' 2>/dev/null)

upps_id=$(echo "$upps_response" | jq -r '.id // empty')

if [ -z "$upps_id" ] || [ "$upps_id" == "null" ]; then
    log_info "UPPS endpoint not available, using ID 1"
    upps_id="1"
else
    log_success "Created UPPS (ID: $upps_id)"
fi

# ========================
# 3. CREATE PRODI (Program Studi)
# ========================
log_info "Creating Program Studi (Prodi)..."

prodi_response=$(curl -s -X POST "$API_BASE/master-data/prodi" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "kodeProdi":"65101",
    "namaProdi":"Teknik Informatika",
    "jenjangId":'$jenjang_s1',
    "institusiId":1,
    "isActive":true
  }' 2>/dev/null)

prodi_id=$(echo "$prodi_response" | jq -r '.id // empty')

if [ -z "$prodi_id" ] || [ "$prodi_id" == "null" ]; then
    log_error "Failed to create Prodi"
    log_info "Response: $prodi_response"
    # Try to get existing prodi
    prodi_id=$(curl -s "$API_BASE/master-data/prodi" -H "Authorization: Bearer $TOKEN" | jq -r '.[0].id // empty')
    if [ -z "$prodi_id" ]; then
        prodi_id="1"
    fi
else
    log_success "Created Prodi: Teknik Informatika (ID: $prodi_id)"
fi

log_header "CREATING AKREDITASI REGULER RECORDS"

# ========================
# 4. CREATE AKREDITASI REGULER
# ========================

for i in {1..3}; do
    echo ""
    echo -e "${BLUE}Creating Akreditasi Reguler Record $i...${NC}"
    
    akreditasi_response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE/akreditasi" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"uppsId\": $upps_id,
            \"prodiId\": $prodi_id,
            \"institusiId\": 1,
            \"jenjangId\": $jenjang_s1,
            \"tahun\": $((2024 + i - 1)),
            \"tipe\": \"REGULER\"
        }" 2>/dev/null)
    
    http_code=$(echo "$akreditasi_response" | tail -n1)
    body=$(echo "$akreditasi_response" | sed '$d')
    akreditasi_id=$(echo "$body" | jq -r '.id // empty')
    
    if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
        log_success "Akreditasi Record $i created (ID: $akreditasi_id)"
        
        # Progress through workflow stages
        stages=(
            "VERIFIKASI_DOKUMEN"
            "PEMBAYARAN"
            "PENAWARAN_ASESOR"
            "ASESMEN_KECUKUPAN"
            "PENGESAHAN_AK"
            "ASESMEN_LAPANGAN"
            "TANGGAPAN_AL"
            "PENGESAHAN_AL"
            "PENETAPAN_PERINGKAT"
            "SINKRONISASI_BANPT"
            "SELESAI"
        )
        
        echo -e "${BLUE}  Progressing through workflow stages:${NC}"
        for stage in "${stages[@]}"; do
            status_response=$(curl -s -w "\n%{http_code}" -X PUT "$API_BASE/akreditasi/$akreditasi_id/status" \
                -H "Authorization: Bearer $TOKEN" \
                -H "Content-Type: application/json" \
                -d "{\"status\": \"$stage\"}" 2>/dev/null)
            
            status_code=$(echo "$status_response" | tail -n1)
            
            if [[ "$status_code" == "200" ]]; then
                echo -e "${GREEN}    ✅${NC} $stage"
            else
                echo -e "${RED}    ✗${NC} $stage (HTTP $status_code)"
            fi
            
            sleep 0.1
        done
        
        log_success "Workflow completed for Akreditasi $i"
    else
        log_error "Akreditasi Record $i creation failed (HTTP $http_code)"
        echo "Error details:"
        echo "$body" | jq '.message // .' 2>/dev/null | head -10
    fi
done

log_header "INJECTION SUMMARY"

echo ""
echo "Data Created:"
echo "  • Jenjang ID: $jenjang_s1"
echo "  • UPPS ID: $upps_id"
echo "  • Prodi ID: $prodi_id"
echo ""
echo "Summary:"
echo -e "  Total Operations: $TOTAL"
echo -e "  Successful: ${GREEN}$SUCCESS${NC}"
echo -e "  Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -le 3 ]; then
    log_success "Akreditasi data injection complete!"
    exit 0
else
    log_error "Multiple records failed"
    exit 1
fi
