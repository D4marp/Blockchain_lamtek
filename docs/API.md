# LAM Teknik SaaS Blockchain API Documentation

## Overview

API ini menyediakan endpoint untuk sistem akreditasi LAM Teknik berbasis blockchain dengan penyimpanan dokumen di IPFS.

## Base URL

```
http://localhost:3000/api/v1
```

## Authentication

Semua endpoint (kecuali health check) memerlukan JWT token:

```
Authorization: Bearer <token>
```

---

## Modules

### 1. Akreditasi Module

#### Register Akreditasi Baru

```http
POST /akreditasi
Content-Type: application/json

{
  "uppsId": 9,
  "prodiId": 138,
  "institusiId": 635,
  "jenjangId": 1,
  "tahun": 2025,
  "tipe": "REGULER"
}
```

**Response:**
```json
{
  "id": 1,
  "kodeAkreditasi": "AKR912381225",
  "status": "REGISTRASI",
  "progress": 0,
  "blockchainTxHash": "0x...",
  "isOnBlockchain": true
}
```

#### Get All Akreditasi

```http
GET /akreditasi?page=1&limit=10&status=REGISTRASI&tipe=REGULER&tahun=2025
```

#### Get Akreditasi by ID

```http
GET /akreditasi/:id
```

#### Get Akreditasi by Kode

```http
GET /akreditasi/kode/:kodeAkreditasi
```

#### Update Status Akreditasi

```http
PUT /akreditasi/:id/status
Content-Type: application/json

{
  "status": "VERIFIKASI_DOKUMEN",
  "keterangan": "Dokumen sedang diverifikasi",
  "ipfsHashBukti": "Qm..."
}
```

#### Upload Dokumen

```http
POST /akreditasi/:id/dokumen
Content-Type: multipart/form-data

file: <file>
tipeDokumen: DOKUMEN_REGISTRASI
```

**Response:**
```json
{
  "ipfsHash": "QmXxxxxx...",
  "url": "http://localhost:8080/ipfs/QmXxxxxx..."
}
```

#### Get Blockchain Status

```http
GET /akreditasi/:id/blockchain
```

**Response:**
```json
{
  "isOnBlockchain": true,
  "txHash": "0x...",
  "blockNumber": 12345,
  "data": {
    "kodeAkreditasi": "AKR...",
    "status": "REGISTRASI",
    "peringkat": "BELUM_TERAKREDITASI"
  },
  "auditLogs": [...]
}
```

---

### 2. Asesmen Kecukupan Module

#### Create Asesmen Kecukupan

```http
POST /asesmen-kecukupan
Content-Type: application/json

{
  "akreditasiId": 1,
  "kodeAkreditasi": "AKR...",
  "keaId": 3,
  "targetWaktuAK": "2025-02-15"
}
```

#### Get Asesmen by Akreditasi

```http
GET /asesmen-kecukupan/akreditasi/:akreditasiId
```

#### Submit Laporan AK

```http
POST /asesmen-kecukupan/:id/laporan
Content-Type: multipart/form-data

file: <file>
deskripsi: "Laporan Asesmen Kecukupan"
```

#### Tetapkan Hasil AK

```http
PUT /asesmen-kecukupan/:id/hasil
Content-Type: application/json

{
  "konsisten": true,
  "skorAkhir": 350.5,
  "notePenetapan": "Hasil AK konsisten dengan standar"
}
```

---

### 3. Asesmen Lapangan Module

#### Create Asesmen Lapangan

```http
POST /asesmen-lapangan
Content-Type: application/json

{
  "akreditasiId": 1,
  "kodeAkreditasi": "AKR...",
  "keaId": 3,
  "targetWaktuAL": "2025-03-15"
}
```

#### Set Jadwal Visitasi

```http
PUT /asesmen-lapangan/:id/jadwal
Content-Type: multipart/form-data

tglVisitasiAwal: 2025-03-10
tglVisitasiAkhir: 2025-03-12
noSuratTugas: 40/BATAP/2025
suratTugas: <file>
```

#### Submit Laporan AL

```http
POST /asesmen-lapangan/:id/laporan
Content-Type: multipart/form-data

laporanAL: <file>
beritaAcara: <file>
umpanBalik: <file>
```

#### Submit Tanggapan AL

```http
POST /asesmen-lapangan/:id/tanggapan
Content-Type: multipart/form-data

file: <file>
dariUPPS: true
```

#### Tetapkan Hasil AL

```http
PUT /asesmen-lapangan/:id/hasil
Content-Type: application/json

{
  "rekomendasiPeringkat": "Baik",
  "notePenetapan": "Hasil AL memenuhi standar minimum",
  "catatanAsesor": "Catatan dari asesor"
}
```

---

### 4. Dokumen Module

#### Upload Dokumen

```http
POST /dokumen/upload/:kodeAkreditasi
Content-Type: multipart/form-data

file: <file>
tipeDokumen: LAPORAN_EVALUASI_DIRI
metadata: {"version": "1.0"}
```

**Response:**
```json
{
  "ipfsHash": "QmXxxxxx...",
  "url": "http://localhost:8080/ipfs/QmXxxxxx...",
  "sha256": "abc123...",
  "blockchainTxHash": "0x..."
}
```

#### Get Dokumen by Akreditasi

```http
GET /dokumen/akreditasi/:kodeAkreditasi
```

#### Download Dokumen

```http
GET /dokumen/ipfs/:hash
```

#### Verify Dokumen Integrity

```http
POST /dokumen/verify/:hash
Content-Type: application/json

{
  "sha256": "abc123..."
}
```

---

### 5. IPFS Module

#### Get IPFS Node Info

```http
GET /ipfs/info
```

#### Upload File to IPFS

```http
POST /ipfs/upload
Content-Type: multipart/form-data

file: <file>
```

#### Upload JSON to IPFS

```http
POST /ipfs/upload-json
Content-Type: application/json

{
  "data": "any json data"
}
```

#### Get File from IPFS

```http
GET /ipfs/file/:hash
```

#### Pin/Unpin File

```http
POST /ipfs/pin/:hash
POST /ipfs/unpin/:hash
```

---

### 6. Blockchain Module

#### Get Blockchain Info

```http
GET /blockchain/info
```

**Response:**
```json
{
  "connected": true,
  "chainId": "1337",
  "blockNumber": 12345,
  "gasPrice": "0",
  "walletAddress": "0x..."
}
```

#### Get Blockchain Stats

```http
GET /blockchain/stats
```

---

### 7. Tenant Module (Multi-tenant)

#### Register Tenant

```http
POST /tenant
Content-Type: application/json

{
  "institusiId": 635,
  "nama": "Universitas Contoh"
}
```

#### Get All Tenants

```http
GET /tenant
```

#### Deactivate Tenant

```http
POST /tenant/:id/deactivate
```

---

### 8. Health Check

```http
GET /health
```

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2025-01-28T10:00:00.000Z",
  "service": "LAM Teknik SaaS API",
  "version": "1.0.0"
}
```

---

## Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |

## Status Akreditasi Flow

```
REGISTRASI → VERIFIKASI_DOKUMEN → PEMBAYARAN → PENAWARAN_ASESOR 
→ ASESMEN_KECUKUPAN → PENGESAHAN_AK → ASESMEN_LAPANGAN 
→ TANGGAPAN_AL → PENGESAHAN_AL → PENETAPAN_PERINGKAT 
→ SINKRONISASI_BANPT → SELESAI
```

## Tipe Dokumen

- `DOKUMEN_REGISTRASI`
- `BUKTI_PEMBAYARAN`
- `LAPORAN_EVALUASI_DIRI`
- `LAPORAN_KINERJA`
- `LAPORAN_AK`
- `LAPORAN_AL`
- `BERITA_ACARA`
- `SURAT_TUGAS`
- `UMPAN_BALIK`
- `TANGGAPAN`
- `SK_AKREDITASI`
- `SERTIFIKAT`
- `LAINNYA`

## Peringkat Akreditasi

- `BELUM_TERAKREDITASI`
- `BAIK`
- `BAIK_SEKALI`
- `UNGGUL`
