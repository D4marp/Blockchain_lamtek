#!/bin/bash

# LAM Teknik - Inject Akreditasi Reguler Data
# Script untuk menyuntik data akreditasi reguler dengan semua tahapan

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
    echo "Usage: $0 <JWT_TOKEN>"
    exit 1
fi

TOKEN=$1

log_header "INJECTING AKREDITASI REGULER DATA"

# ============================================
# Helper function untuk create data
# ============================================
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
    
    if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
        log_success "$description (HTTP $http_code)"
        echo "$body" | jq -r '.id // empty'
        return 0
    else
        log_error "$description - HTTP $http_code"
        echo "$body" | jq . 2>/dev/null || echo "Response: $body"
        return 1
    fi
}

# Get institusi ID (untuk test data menggunakan institusi pertama)
log_info "Mengambil ID institusi..."
institusi_response=$(curl -s -X GET "$API_BASE/master-data/institusi?take=1" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null)

institusi_id=$(echo "$institusi_response" | jq -r '.data[0].id // empty')

if [ -z "$institusi_id" ]; then
    log_error "Institusi tidak ditemukan. Pastikan data institusi sudah di-inject."
    exit 1
fi

log_success "Institusi ID: $institusi_id"

# Get prodi ID (menggunakan prodi pertama atau create dummy)
log_info "Mengambil ID program studi..."
prodi_response=$(curl -s -X GET "$API_BASE/master-data/prodi?take=1" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null)

prodi_id=$(echo "$prodi_response" | jq -r '.data[0].id // empty')

if [ -z "$prodi_id" ]; then
    log_info "Program studi tidak ditemukan, membuat data dummy..."
    prodi_data='{"namaProdi":"Teknik Informatika","institusiId":'$institusi_id',"jenjangId":1,"kodeProgs":"12345"}'
    prodi_id=$(create_data "/master-data/prodi" "$prodi_data" "Membuat Program Studi dummy")
    if [ -z "$prodi_id" ]; then
        log_error "Gagal membuat program studi"
        exit 1
    fi
fi

log_success "Program Studi ID: $prodi_id"

# ============================================
# 1. REGISTRASI AKREDITASI
# ============================================
log_header "1. REGISTRASI AKREDITASI"

registrasi_data='{
    "prodiId": '$prodi_id',
    "institusiId": '$institusi_id',
    "tahunAkademik": "2024/2025",
    "tanggalRegistrasi": "2024-01-15T00:00:00Z",
    "status": "submitted",
    "nomorRegistrasi": "REG-2024-001",
    "jenisAkreditasi": "Akreditasi Reguler",
    "keterangan": "Registrasi akreditasi reguler untuk program studi Teknik Informatika"
}'

registrasi_id=$(create_data "/proses-akreditasi/registrasi-akreditasi" "$registrasi_data" "Registrasi Akreditasi")
if [ -z "$registrasi_id" ]; then
    registrasi_id="1"  # Use dummy ID for next steps
fi

# ============================================
# 2. VERIFIKASI REGISTRASI
# ============================================
log_header "2. VERIFIKASI REGISTRASI"

verifikasi_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "tanggalVerifikasi": "2024-01-20T00:00:00Z",
    "status": "verified",
    "verifikatorId": 1,
    "catatanVerifikasi": "Dokumen lengkap dan sesuai standar"
}'

create_data "/proses-akreditasi/registrasi-akreditasi/$registrasi_id" "$verifikasi_data" "Verifikasi Registrasi" || true

# ============================================
# 3. PENAWARAN ASESOR
# ============================================
log_header "3. PENAWARAN ASESOR"

penawaran_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "daftarAsesor": [
        {
            "asesorId": 1,
            "namaPenawaran": "Penawaran Asesor 1",
            "tanggalPenawaran": "2024-01-22T00:00:00Z"
        },
        {
            "asesorId": 2,
            "namaPenawaran": "Penawaran Asesor 2",
            "tanggalPenawaran": "2024-01-22T00:00:00Z"
        }
    ],
    "status": "draft",
    "keterangan": "Penawaran asesor untuk akreditasi reguler"
}'

penawaran_id=$(create_data "/proses-akreditasi/penawaran-asesor" "$penawaran_data" "Penawaran Asesor") || echo "1"

# ============================================
# 4. RESPON ASESOR
# ============================================
log_header "4. RESPON ASESOR"

respon_data='{
    "penawaranAsesorId": '$penawaran_id',
    "asesorId": 1,
    "tanggalRespon": "2024-01-25T00:00:00Z",
    "status": "accepted",
    "keterangan": "Asesor menerima penawaran untuk melakukan asesmen"
}'

respon_id=$(create_data "/proses-akreditasi/respon-asesor" "$respon_data" "Respon Asesor") || echo "1"

# ============================================
# 5. ASESMEN KECUKUPAN
# ============================================
log_header "5. ASESMEN KECUKUPAN"

ak_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "asesorId": 1,
    "tanggalAk": "2024-02-01T00:00:00Z",
    "status": "completed",
    "nilaiAk": 85,
    "keterangan": "Asesmen kecukupan selesai dengan nilai 85",
    "dokumenAk": "https://example.com/ak-doc.pdf"
}'

ak_id=$(create_data "/proses-akreditasi/asesmen-kecukupan" "$ak_data" "Asesmen Kecukupan") || echo "1"

# ============================================
# 6. PENGESAHAN AK (KEA)
# ============================================
log_header "6. PENGESAHAN AK (KEA)"

pengesahan_ak_data='{
    "asesmenKecukupanId": '$ak_id',
    "registrasiAkreditasiId": '$registrasi_id',
    "tanggalPengesahan": "2024-02-05T00:00:00Z",
    "status": "approved",
    "keputusan": "Lulus",
    "keterangan": "Asesmen kecukupan disetujui oleh KEA"
}'

pengesahan_ak_id=$(create_data "/proses-akreditasi/pengesahan-ak" "$pengesahan_ak_data" "Pengesahan AK (KEA)") || echo "1"

# ============================================
# 7. ASESMEN LAPANGAN
# ============================================
log_header "7. ASESMEN LAPANGAN"

al_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "asesorId": 1,
    "tanggalKunjunganAwal": "2024-02-10T00:00:00Z",
    "tanggalKunjunganAkhir": "2024-02-12T00:00:00Z",
    "status": "completed",
    "nilaiAl": 88,
    "keterangan": "Asesmen lapangan selesai dengan nilai 88",
    "dokumenAl": "https://example.com/al-doc.pdf"
}'

al_id=$(create_data "/proses-akreditasi/asesmen-lapangan" "$al_data" "Asesmen Lapangan") || echo "1"

# ============================================
# 8. TANGGAPAN AL
# ============================================
log_header "8. TANGGAPAN AL"

tanggapan_al_data='{
    "asesmenLapanganId": '$al_id',
    "registrasiAkreditasiId": '$registrasi_id',
    "tanggalTanggapan": "2024-02-15T00:00:00Z",
    "status": "submitted",
    "tanggapan": "Kami setuju dengan temuan asesor lapangan",
    "dokumenTanggapan": "https://example.com/tanggapan-al.pdf"
}'

tanggapan_al_id=$(create_data "/proses-akreditasi/tanggapan-al" "$tanggapan_al_data" "Tanggapan AL") || echo "1"

# ============================================
# 9. PENGESAHAN AL (KEA)
# ============================================
log_header "9. PENGESAHAN AL (KEA)"

pengesahan_al_data='{
    "asesmenLapanganId": '$al_id',
    "registrasiAkreditasiId": '$registrasi_id',
    "tanggalPengesahan": "2024-02-20T00:00:00Z",
    "status": "approved",
    "keputusan": "Lulus",
    "nilaiAkhir": 88,
    "keterangan": "Asesmen lapangan disetujui oleh KEA"
}'

pengesahan_al_id=$(create_data "/proses-akreditasi/pengesahan-al" "$pengesahan_al_data" "Pengesahan AL (KEA)") || echo "1"

# ============================================
# 10. KEPUTUSAN MA
# ============================================
log_header "10. KEPUTUSAN MA"

keputusan_ma_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "tanggalKeputusan": "2024-02-25T00:00:00Z",
    "status": "approved",
    "keputusan": "Akreditasi Terakreditasi (A)",
    "nilaiAkhir": 88,
    "masaPerlakuAkreditasi": 5,
    "tanggalMulai": "2024-03-01T00:00:00Z",
    "tanggalBerakhir": "2029-02-28T00:00:00Z",
    "keterangan": "Program studi mendapat status akreditasi A (terakreditasi)"
}'

keputusan_ma_id=$(create_data "/proses-akreditasi/keputusan-ma" "$keputusan_ma_data" "Keputusan MA") || echo "1"

# ============================================
# 11. SINKRONISASI BANPT
# ============================================
log_header "11. SINKRONISASI BANPT"

sinkronisasi_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "keputusanMaId": '$keputusan_ma_id',
    "tanggalSinkronisasi": "2024-02-28T00:00:00Z",
    "status": "synced",
    "nomorSkBanpt": "SK-BANPT-2024-001",
    "keterangan": "Data sinkronisasi ke BANPT berhasil"
}'

sinkronisasi_id=$(create_data "/proses-akreditasi/sinkronisasi-banpt" "$sinkronisasi_data" "Sinkronisasi BANPT") || echo "1"

# ============================================
# 12. REGISTRASI PRODI BARU
# ============================================
log_header "12. REGISTRASI PRODI BARU"

registrasi_prodi_baru_data='{
    "institusiId": '$institusi_id',
    "namaProdi": "Teknik Elektro (Program Studi Baru)",
    "jenjangId": 1,
    "tahunOperasional": 2024,
    "status": "submitted",
    "keterangan": "Registrasi program studi baru Teknik Elektro"
}'

registrasi_prodi_baru_id=$(create_data "/proses-akreditasi/registrasi-prodi-baru" "$registrasi_prodi_baru_data" "Registrasi Prodi Baru") || echo "1"

# ============================================
# 13. PENUNJUKAN VALIDATOR
# ============================================
log_header "13. PENUNJUKAN VALIDATOR"

validator_data='{
    "registrasiProdiBaru": '$registrasi_prodi_baru_id',
    "asesorId": 1,
    "tanggalPenunjukan": "2024-03-01T00:00:00Z",
    "status": "assigned",
    "keterangan": "Penunjukan validator untuk registrasi prodi baru"
}'

validator_id=$(create_data "/proses-akreditasi/validator" "$validator_data" "Penunjukan Validator") || echo "1"

# ============================================
# 14. SK AKREDITASI
# ============================================
log_header "14. SK AKREDITASI"

sk_akreditasi_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "keputusanMaId": '$keputusan_ma_id',
    "nomorSk": "SK-LAMTEK-2024-001",
    "tanggalSk": "2024-02-28T00:00:00Z",
    "tanggalMulai": "2024-03-01T00:00:00Z",
    "tanggalBerakhir": "2029-02-28T00:00:00Z",
    "status": "issued",
    "dokumenSk": "https://example.com/sk-lamtek.pdf",
    "keterangan": "SK Akreditasi telah diterbitkan"
}'

sk_id=$(create_data "/proses-akreditasi/sk-akreditasi" "$sk_akreditasi_data" "SK Akreditasi") || echo "1"

# ============================================
# 15. LAPORAN ASESMEN
# ============================================
log_header "15. LAPORAN ASESMEN"

laporan_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "asesorId": 1,
    "tanggalLaporan": "2024-02-15T00:00:00Z",
    "status": "completed",
    "ringkasanLaporan": "Laporan asesmen menyeluruh untuk program studi Teknik Informatika",
    "dokumenLaporan": "https://example.com/laporan-asesmen.pdf",
    "nilaiAkhir": 88
}'

laporan_id=$(create_data "/proses-akreditasi/laporan-asesmen" "$laporan_data" "Laporan Asesmen") || echo "1"

# ============================================
# 16. UMPAN BALIK
# ============================================
log_header "16. UMPAN BALIK"

umpan_balik_data='{
    "registrasiAkreditasiId": '$registrasi_id',
    "asesorId": 1,
    "tanggalUmpaanBalik": "2024-02-20T00:00:00Z",
    "status": "submitted",
    "kategori": "Rekomendasi Perbaikan",
    "isi": "Program studi perlu meningkatkan kualitas dosen dan fasilitas laboratorium",
    "dokumenUmpaanBalik": "https://example.com/umpan-balik.pdf"
}'

umpan_balik_id=$(create_data "/proses-akreditasi/umpan-balik" "$umpan_balik_data" "Umpan Balik") || echo "1"

# ============================================
# SUMMARY
# ============================================
log_header "SUMMARY"

echo "Total Data: $TOTAL"
echo -e "Success: ${GREEN}$SUCCESS${NC}"
echo -e "Failed:  ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    log_success "Semua data akreditasi reguler berhasil di-inject!"
    exit 0
else
    echo -e "${YELLOW}Beberapa data gagal, silakan periksa error di atas${NC}"
    exit 1
fi
