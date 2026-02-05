#!/bin/bash

# LAM Teknik - Akreditasi Reguler Data Injection Script
# Script lengkap untuk menyuntik data akreditasi reguler dengan semua tahapan

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
    echo ""
    echo "Cara mendapatkan token:"
    echo "1. Pastikan backend running: cd backend && npm run start:dev"
    echo "2. Di terminal baru, jalankan:"
    echo ""
    echo "   ./GET_TOKEN.sh"
    echo ""
    echo "3. Salin token dan jalankan:"
    echo ""
    echo "   ./INJECT_AKREDITASI_REGULER.sh <TOKEN>"
    echo ""
    exit 1
fi

set -e

TOKEN=$1

log_header "INJECTING AKREDITASI REGULER DATA"

# Helper function untuk create data
create_data() {
    local endpoint="$1"
    local data="$2"
    local description="$3"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$API_BASE$endpoint" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "$data" 2>/dev/null)
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    id=$(echo "$body" | jq -r '.id // empty')
    
    if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
        log_success "$description"
        echo "$id"
        return 0
    else
        log_error "$description (HTTP $http_code)"
        echo "$body" | jq . 2>/dev/null || echo "Error: $body"
        return 1
    fi
}

# Get institusi ID
log_info "Mengambil data institusi..."
institusi_response=$(curl -s -X GET "$API_BASE/master-data/institusi?take=5" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null)

institusi_id=$(echo "$institusi_response" | jq -r '.[0].id // empty')
institusi_nama=$(echo "$institusi_response" | jq -r '.[0].namaInstitusi // empty')

if [ -z "$institusi_id" ]; then
    log_error "Institusi tidak ditemukan!"
    log_info "Pastikan data master-data sudah di-inject terlebih dahulu"
    exit 1
fi

log_success "Menggunakan institusi: $institusi_nama (ID: $institusi_id)"

# ========================
# 1. CREATE PROGRAM STUDI (PRODI)
# ========================
log_header "CREATING PROGRAM STUDI (PRODI)"

prodi_data='{
    "kodiakreditasi": "PRODI_001",
    "namaProdi": "Teknik Informatika",
    "levelJenjang": "S1",
    "noSKPengusulan": "SK/2024/001",
    "tglSKPengusulan": "2024-01-15",
    "institusiId": '$institusi_id'
}'

prodi_id=$(create_data "/akreditasi-reguler/prodi" "$prodi_data" "Create Prodi: Teknik Informatika")

# ========================
# 2. REGISTRASI AKREDITASI
# ========================
log_header "STAGE 1: REGISTRASI AKREDITASI"

registrasi_data='{
    "prodiId": '$prodi_id',
    "tglPengajuan": "2024-02-01",
    "tglDiprosesAdmin": "2024-02-02",
    "statusRegistrasi": "APPROVED",
    "noRegistrasi": "REG/2024/001",
    "tglRegistrasi": "2024-02-05"
}'

registrasi_id=$(create_data "/akreditasi-reguler/registrasi" "$registrasi_data" "Registrasi Akreditasi")

# ========================
# 3. VERIFIKASI REGISTRASI
# ========================
log_header "STAGE 2: VERIFIKASI REGISTRASI"

verifikasi_data='{
    "registrasiId": '$registrasi_id',
    "tglVerifikasi": "2024-02-10",
    "hasilVerifikasi": "PASS",
    "catatan": "Dokumen lengkap dan sesuai"
}'

verifikasi_id=$(create_data "/akreditasi-reguler/verifikasi" "$verifikasi_data" "Verifikasi Registrasi")

# ========================
# 4. PENAWARAN ASESOR
# ========================
log_header "STAGE 3: PENAWARAN ASESOR"

penawaran_data='{
    "registrasiId": '$registrasi_id',
    "tglPenawaran": "2024-02-15",
    "nomorSurat": "SURAT/ASESOR/2024/001",
    "statusPenawaran": "SENT"
}'

penawaran_id=$(create_data "/akreditasi-reguler/penawaran-asesor" "$penawaran_data" "Penawaran Asesor")

# ========================
# 5. RESPON ASESOR
# ========================
log_header "STAGE 4: RESPON ASESOR"

respon_data='{
    "penawaranId": '$penawaran_id',
    "tglRespon": "2024-02-20",
    "status": "ACCEPTED",
    "catatan": "Siap untuk asesmen"
}'

respon_id=$(create_data "/akreditasi-reguler/respon-asesor" "$respon_data" "Respon Asesor")

# ========================
# 6. ASESMEN KECUKUPAN (AK)
# ========================
log_header "STAGE 5: ASESMEN KECUKUPAN"

ak_data='{
    "registrasiId": '$registrasi_id',
    "tglAsesmen": "2024-03-01",
    "hasilAsesmen": "PASS",
    "skor": 85,
    "catatan": "Semua kriteria terpenuhi"
}'

ak_id=$(create_data "/akreditasi-reguler/asesmen-kecukupan" "$ak_data" "Asesmen Kecukupan")

# ========================
# 7. PENGESAHAN AK (KEA)
# ========================
log_header "STAGE 6: PENGESAHAN ASESMEN KECUKUPAN"

pengesahan_ak_data='{
    "asesmenKecukupanId": '$ak_id',
    "tglPengesahan": "2024-03-10",
    "status": "APPROVED",
    "nomorKeputusan": "KEP/AK/2024/001"
}'

pengesahan_ak_id=$(create_data "/akreditasi-reguler/pengesahan-ak" "$pengesahan_ak_data" "Pengesahan Asesmen Kecukupan")

# ========================
# 8. ASESMEN LAPANGAN (AL)
# ========================
log_header "STAGE 7: ASESMEN LAPANGAN"

al_data='{
    "registrasiId": '$registrasi_id',
    "tglAsesmen": "2024-04-01",
    "tglSelesaiAsesmen": "2024-04-05",
    "hasilAsesmen": "PASS",
    "skor": 88,
    "catatan": "Standar terpenuhi dengan baik"
}'

al_id=$(create_data "/akreditasi-reguler/asesmen-lapangan" "$al_data" "Asesmen Lapangan")

# ========================
# 9. TANGGAPAN ASESMEN LAPANGAN
# ========================
log_header "STAGE 8: TANGGAPAN ASESMEN LAPANGAN"

tanggapan_al_data='{
    "asesmenLapanganId": '$al_id',
    "tglTanggapan": "2024-04-15",
    "respons": "Terima hasil asesmen",
    "catatan": "Program siap untuk pengesahan"
}'

tanggapan_al_id=$(create_data "/akreditasi-reguler/tanggapan-al" "$tanggapan_al_data" "Tanggapan Asesmen Lapangan")

# ========================
# 10. PENGESAHAN ASESMEN LAPANGAN (KEA)
# ========================
log_header "STAGE 9: PENGESAHAN ASESMEN LAPANGAN"

pengesahan_al_data='{
    "asesmenLapanganId": '$al_id',
    "tglPengesahan": "2024-04-25",
    "status": "APPROVED",
    "nomorKeputusan": "KEP/AL/2024/001"
}'

pengesahan_al_id=$(create_data "/akreditasi-reguler/pengesahan-al" "$pengesahan_al_data" "Pengesahan Asesmen Lapangan")

# ========================
# 11. KEPUTUSAN MAJELIS AKREDITASI (MA)
# ========================
log_header "STAGE 10: KEPUTUSAN MAJELIS AKREDITASI"

keputusan_ma_data='{
    "registrasiId": '$registrasi_id',
    "tglKeputusan": "2024-05-01",
    "status": "ACCREDITED",
    "peringkatAkreditasi": "A",
    "nomorKeputusan": "KEP/MA/2024/001",
    "tglBerlakuAwal": "2024-05-01",
    "tglBerlakuAkhir": "2027-05-01"
}'

keputusan_ma_id=$(create_data "/akreditasi-reguler/keputusan-ma" "$keputusan_ma_data" "Keputusan Majelis Akreditasi")

# ========================
# 12. SINKRONISASI BANPT
# ========================
log_header "STAGE 11: SINKRONISASI BANPT"

sinkronisasi_data='{
    "keputusanMAId": '$keputusan_ma_id',
    "tglSinkronisasi": "2024-05-10",
    "status": "SYNCED",
    "noSuratBANPT": "BANPT/2024/001",
    "catatan": "Data berhasil disinkronisasi dengan BANPT"
}'

sinkronisasi_id=$(create_data "/akreditasi-reguler/sinkronisasi-banpt" "$sinkronisasi_data" "Sinkronisasi BANPT")

# ========================
# 13. SK AKREDITASI
# ========================
log_header "ADDITIONAL: SK AKREDITASI"

sk_akreditasi_data='{
    "keputusanMAId": '$keputusan_ma_id',
    "noSK": "SK/AKREDITASI/2024/001",
    "tglSK": "2024-05-15",
    "fileUrl": "https://lamtek.ac.id/sk-akreditasi-2024-001.pdf"
}'

sk_akreditasi_id=$(create_data "/akreditasi-reguler/sk-akreditasi" "$sk_akreditasi_data" "SK Akreditasi")

# ========================
# 14. LAPORAN ASESMEN
# ========================
log_header "ADDITIONAL: LAPORAN ASESMEN"

laporan_data='{
    "asesmenLapanganId": '$al_id',
    "noLaporan": "LAP/ASESMEN/2024/001",
    "tglLaporan": "2024-04-20",
    "fileUrl": "https://lamtek.ac.id/laporan-asesmen-2024-001.pdf"
}'

laporan_id=$(create_data "/akreditasi-reguler/laporan-asesmen" "$laporan_data" "Laporan Asesmen")

# ========================
# 15. UMPAN BALIK
# ========================
log_header "ADDITIONAL: UMPAN BALIK"

umpan_balik_data='{
    "asesmenLapanganId": '$al_id',
    "tglUmpanBalik": "2024-04-10",
    "isiUmpanBalik": "Program sudah menunjukkan peningkatan yang signifikan dalam aspek kurikulum dan kualitas dosen",
    "kategori": "RECOMMENDATIONS"
}'

umpan_balik_id=$(create_data "/akreditasi-reguler/umpan-balik" "$umpan_balik_data" "Umpan Balik")

# ========================
# SUMMARY
# ========================
log_header "INJECTION SUMMARY"

echo ""
echo -e "${BLUE}Created Data:${NC}"
echo "  • Prodi ID: $prodi_id"
echo "  • Registrasi ID: $registrasi_id"
echo "  • Verifikasi ID: $verifikasi_id"
echo "  • Penawaran Asesor ID: $penawaran_id"
echo "  • Respon Asesor ID: $respon_id"
echo "  • Asesmen Kecukupan ID: $ak_id"
echo "  • Pengesahan AK ID: $pengesahan_ak_id"
echo "  • Asesmen Lapangan ID: $al_id"
echo "  • Tanggapan AL ID: $tanggapan_al_id"
echo "  • Pengesahan AL ID: $pengesahan_al_id"
echo "  • Keputusan MA ID: $keputusan_ma_id"
echo "  • Sinkronisasi BANPT ID: $sinkronisasi_id"
echo "  • SK Akreditasi ID: $sk_akreditasi_id"
echo "  • Laporan Asesmen ID: $laporan_id"
echo "  • Umpan Balik ID: $umpan_balik_id"
echo ""

echo "Summary:"
echo "  Total Operations: $TOTAL"
echo -e "  Successful: ${GREEN}$SUCCESS${NC}"
echo -e "  Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    log_success "Semua data berhasil di-inject!"
    exit 0
else
    log_error "$FAILED data gagal di-inject"
    exit 1
fi
