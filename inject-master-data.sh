#!/bin/bash

# LAM Teknik - Master Data API Injection Script
# Script ini inject test data one-by-one ke semua master-data endpoints

set -e

API_BASE="http://localhost:3003/api/v1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print section
print_section() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if token is provided
if [ -z "$1" ]; then
    print_error "Token not provided"
    echo "Usage: ./inject-master-data.sh YOUR_JWT_TOKEN"
    echo ""
    echo "Get token from login first:"
    echo "  curl -X POST http://localhost:3003/api/v1/auth/login \\"
    echo "    -H 'Content-Type: application/json' \\"
    echo "    -d '{\"email\":\"admin@lamtek.ac.id\",\"password\":\"password123\"}'"
    exit 1
fi

TOKEN=$1
HEADER_JSON="Content-Type: application/json"
HEADER_AUTH="Authorization: Bearer $TOKEN"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║       LAM Teknik - Master Data API Injection Script           ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Test token validity
print_section "Testing API Connection & Token..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET $API_BASE/auth/me \
  -H "$HEADER_AUTH")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" != "200" ]; then
    print_error "Invalid token or API not responding"
    echo "HTTP Code: $HTTP_CODE"
    echo "Response: $BODY"
    exit 1
fi

LOGGED_IN_USER=$(echo "$BODY" | jq -r '.email')
print_success "API connected. Logged in as: $LOGGED_IN_USER"

# ========================
# 1. PROVINSI (Province)
# ========================
print_section "1. Injecting PROVINSI (Provinces)..."

PROVINSI_DATA=(
    '{"kodeProvinsi":"11","namaProvinsi":"Aceh"}'
    '{"kodeProvinsi":"12","namaProvinsi":"Sumatera Utara"}'
    '{"kodeProvinsi":"13","namaProvinsi":"Sumatera Barat"}'
    '{"kodeProvinsi":"14","namaProvinsi":"Riau"}'
    '{"kodeProvinsi":"15","namaProvinsi":"Jambi"}'
    '{"kodeProvinsi":"16","namaProvinsi":"Sumatera Selatan"}'
    '{"kodeProvinsi":"17","namaProvinsi":"Bengkulu"}'
    '{"kodeProvinsi":"18","namaProvinsi":"Lampung"}'
    '{"kodeProvinsi":"31","namaProvinsi":"DKI Jakarta"}'
    '{"kodeProvinsi":"32","namaProvinsi":"Jawa Barat"}'
    '{"kodeProvinsi":"33","namaProvinsi":"Jawa Tengah"}'
    '{"kodeProvinsi":"34","namaProvinsi":"DI Yogyakarta"}'
    '{"kodeProvinsi":"35","namaProvinsi":"Jawa Timur"}'
)

CREATED_PROVINSI=0
for data in "${PROVINSI_DATA[@]}"; do
    KODE=$(echo "$data" | jq -r '.kodeProvinsi')
    NAMA=$(echo "$data" | jq -r '.namaProvinsi')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST $API_BASE/master-data/provinsi \
      -H "$HEADER_JSON" \
      -H "$HEADER_AUTH" \
      -d "$data")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        print_success "Provinsi: $KODE - $NAMA"
        ((CREATED_PROVINSI++))
    else
        # If conflict (already exists), it's okay
        if [ "$HTTP_CODE" = "409" ] || [ "$HTTP_CODE" = "400" ]; then
            echo "   ℹ️  $NAMA (already exists or skipped)"
        else
            print_error "Provinsi: $NAMA (HTTP $HTTP_CODE)"
            echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
        fi
    fi
done
echo "   Created: $CREATED_PROVINSI provinsi"

# ========================
# 2. INSTITUSI
# ========================
print_section "2. Injecting INSTITUSI..."

INSTITUSI_DATA=(
    '{"kodeInstitusi":"ITB","namaInstitusi":"Institut Teknologi Bandung","namaSingkat":"ITB","jenisPt":"PTN","alamat":"Jl. Ganesha 10","kota":"Bandung","kodePos":"40132","telepon":"0274-515591","email":"info@itb.ac.id","website":"https://www.itb.ac.id","status":"AKTIF"}'
    '{"kodeInstitusi":"UNPAD","namaInstitusi":"Universitas Padjadjaran","namaSingkat":"UNPAD","jenisPt":"PTN","alamat":"Jl. Raya Bandung - Sumedang","kota":"Jatinangor","kodePos":"45363","telepon":"022-7798200","email":"info@unpad.ac.id","website":"https://www.unpad.ac.id","status":"AKTIF"}'
    '{"kodeInstitusi":"UNIBRAW","namaInstitusi":"Universitas Brawijaya","namaSingkat":"UNIBRAW","jenisPt":"PTN","alamat":"Jl. Veteran","kota":"Malang","kodePos":"65145","telepon":"0341-575661","email":"info@ub.ac.id","website":"https://www.ub.ac.id","status":"AKTIF"}'
    '{"kodeInstitusi":"MARANATHA","namaInstitusi":"Universitas Kristen Maranatha","namaSingkat":"MARANATHA","jenisPt":"PTS","alamat":"Jl. Sumbawa 5","kota":"Bandung","kodePos":"40164","telepon":"022-7204535","email":"info@maranatha.ac.id","website":"https://www.maranatha.ac.id","status":"AKTIF"}'
    '{"kodeInstitusi":"TARUMANAGARA","namaInstitusi":"Universitas Tarumanagara","namaSingkat":"UNTAR","jenisPt":"PTS","alamat":"Jl. Letjend S. Parman No. 1","kota":"Jakarta","kodePos":"11440","telepon":"021-5664525","email":"info@untar.ac.id","website":"https://www.untar.ac.id","status":"AKTIF"}'
    '{"kodeInstitusi":"POLMAN","namaInstitusi":"Politeknik Manufaktur Bandung","namaSingkat":"POLMAN","jenisPt":"POLITEKNIK","alamat":"Jl. Tanjungsari No. 1","kota":"Bandung","kodePos":"40243","telepon":"022-5202399","email":"info@polman.ac.id","website":"https://www.polman.ac.id","status":"AKTIF"}'
)

CREATED_INSTITUSI=0
INSTITUSI_IDS=()
for data in "${INSTITUSI_DATA[@]}"; do
    KODE=$(echo "$data" | jq -r '.kodeInstitusi')
    NAMA=$(echo "$data" | jq -r '.namaInstitusi')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST $API_BASE/master-data/institusi \
      -H "$HEADER_JSON" \
      -H "$HEADER_AUTH" \
      -d "$data")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        INSTITUSI_ID=$(echo "$BODY" | jq -r '.id // empty')
        if [ ! -z "$INSTITUSI_ID" ]; then
            INSTITUSI_IDS+=("$INSTITUSI_ID")
        fi
        print_success "Institusi: $KODE - $NAMA"
        ((CREATED_INSTITUSI++))
    else
        if [ "$HTTP_CODE" = "409" ] || [ "$HTTP_CODE" = "400" ]; then
            echo "   ℹ️  $NAMA (already exists or skipped)"
            # Try to get ID from database
            GET_RESPONSE=$(curl -s -X GET "$API_BASE/master-data/institusi/kode/$KODE" \
              -H "$HEADER_AUTH")
            INST_ID=$(echo "$GET_RESPONSE" | jq -r '.id // empty')
            if [ ! -z "$INST_ID" ]; then
                INSTITUSI_IDS+=("$INST_ID")
            fi
        else
            print_error "Institusi: $NAMA (HTTP $HTTP_CODE)"
            echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
        fi
    fi
done
echo "   Created/Found: $CREATED_INSTITUSI institusi"

# ========================
# 3. JENJANG
# ========================
print_section "3. Injecting JENJANG (Academic Level)..."

JENJANG_DATA=(
    '{"kodeJenjang":"D3","namaJenjang":"Diploma 3"}'
    '{"kodeJenjang":"S1","namaJenjang":"Strata 1"}'
    '{"kodeJenjang":"S2","namaJenjang":"Strata 2"}'
    '{"kodeJenjang":"S3","namaJenjang":"Strata 3"}'
    '{"kodeJenjang":"PROFF","namaJenjang":"Profesi"}'
)

CREATED_JENJANG=0
for data in "${JENJANG_DATA[@]}"; do
    KODE=$(echo "$data" | jq -r '.kodeJenjang')
    NAMA=$(echo "$data" | jq -r '.namaJenjang')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST $API_BASE/master-data/jenjang \
      -H "$HEADER_JSON" \
      -H "$HEADER_AUTH" \
      -d "$data")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        print_success "Jenjang: $KODE - $NAMA"
        ((CREATED_JENJANG++))
    else
        if [ "$HTTP_CODE" = "409" ] || [ "$HTTP_CODE" = "400" ]; then
            echo "   ℹ️  $NAMA (already exists or skipped)"
        else
            echo "   ⚠️  $NAMA (HTTP $HTTP_CODE)"
        fi
    fi
done
echo "   Created: $CREATED_JENJANG jenjang"

# ========================
# 4. KLASTER ILMU
# ========================
print_section "4. Injecting KLASTER ILMU..."

KLASTER_ILMU_DATA=(
    '{"kodeKlasterIlmu":"SAINTEK","namaKlasterIlmu":"Sains dan Teknologi"}'
    '{"kodeKlasterIlmu":"SOSIAL","namaKlasterIlmu":"Ilmu Sosial"}'
    '{"kodeKlasterIlmu":"HUMANIORA","namaKlasterIlmu":"Humaniora"}'
    '{"kodeKlasterIlmu":"KESEHATAN","namaKlasterIlmu":"Kesehatan"}'
)

CREATED_KLASTER=0
for data in "${KLASTER_ILMU_DATA[@]}"; do
    KODE=$(echo "$data" | jq -r '.kodeKlasterIlmu')
    NAMA=$(echo "$data" | jq -r '.namaKlasterIlmu')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST $API_BASE/master-data/klaster-ilmu \
      -H "$HEADER_JSON" \
      -H "$HEADER_AUTH" \
      -d "$data")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        print_success "Klaster Ilmu: $KODE - $NAMA"
        ((CREATED_KLASTER++))
    else
        if [ "$HTTP_CODE" = "409" ] || [ "$HTTP_CODE" = "400" ]; then
            echo "   ℹ️  $NAMA (already exists or skipped)"
        else
            echo "   ⚠️  $NAMA (HTTP $HTTP_CODE)"
        fi
    fi
done
echo "   Created: $CREATED_KLASTER klaster ilmu"

# ========================
# 5. STATUS INSTITUSI
# ========================
print_section "5. Injecting STATUS INSTITUSI..."

STATUS_DATA=(
    '{"kodeStatus":"AKTIF","namaStatus":"Aktif"}'
    '{"kodeStatus":"TIDAK_AKTIF","namaStatus":"Tidak Aktif"}'
    '{"kodeStatus":"SUSPENDED","namaStatus":"Suspended"}'
)

CREATED_STATUS=0
for data in "${STATUS_DATA[@]}"; do
    KODE=$(echo "$data" | jq -r '.kodeStatus')
    NAMA=$(echo "$data" | jq -r '.namaStatus')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST $API_BASE/master-data/status-institusi \
      -H "$HEADER_JSON" \
      -H "$HEADER_AUTH" \
      -d "$data")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
        print_success "Status: $KODE - $NAMA"
        ((CREATED_STATUS++))
    else
        if [ "$HTTP_CODE" = "409" ] || [ "$HTTP_CODE" = "400" ]; then
            echo "   ℹ️  $NAMA (already exists or skipped)"
        else
            echo "   ⚠️  $NAMA (HTTP $HTTP_CODE)"
        fi
    fi
done
echo "   Created: $CREATED_STATUS status"

# ========================
# Summary
# ========================
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                        Data Injection Summary                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Master Data Seeding Complete!"
echo ""
echo "Summary:"
echo "  • Provinsi:        $CREATED_PROVINSI created"
echo "  • Institusi:       $CREATED_INSTITUSI created"
echo "  • Jenjang:         $CREATED_JENJANG created"
echo "  • Klaster Ilmu:    $CREATED_KLASTER created"
echo "  • Status Institusi: $CREATED_STATUS created"
echo ""
echo "Institusi IDs for reference:"
for i in "${!INSTITUSI_IDS[@]}"; do
    echo "  [$((i+1))] ID: ${INSTITUSI_IDS[$i]}"
done
echo ""
echo "✨ All data has been injected successfully!"
echo ""
