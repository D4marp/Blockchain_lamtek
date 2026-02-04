# LAM Teknik SaaS Blockchain Platform

Sistem Akreditasi Program Studi LAM Teknik berbasis Blockchain (Hyperledger Besu) dengan IPFS untuk penyimpanan dokumen terdistribusi.

## 🏗️ Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           LAM Teknik SaaS Platform                          │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│  │   Container 1   │  │   Container 2   │  │   Container 3   │              │
│  │   API Gateway   │  │  Besu Node 1    │  │  Besu Node 2    │              │
│  │   + Backend     │  │  (Validator)    │  │  (Validator)    │              │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘              │
│           │                    │                    │                        │
│           └────────────────────┼────────────────────┘                        │
│                                │                                             │
│  ┌─────────────────────────────┴─────────────────────────────┐              │
│  │                     Container 4                            │              │
│  │              IPFS Node + Document Service                  │              │
│  └────────────────────────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 📦 Modul SaaS

### 1. **Modul Registrasi Akreditasi**
- Registrasi akreditasi reguler & PJJ
- Registrasi akreditasi prodi baru (PTNBH/Non-PTNBH)
- Verifikasi dokumen dan pembayaran

### 2. **Modul Asesmen Kecukupan (AK)**
- Penunjukan validator/asesor
- Penilaian dokumen
- Penetapan hasil AK oleh KEA/Validator

### 3. **Modul Asesmen Lapangan (AL)**
- Penjadwalan visitasi
- Penilaian lapangan
- Tanggapan dan umpan balik

### 4. **Modul Penetapan Akreditasi**
- Keputusan peringkat oleh Majelis Akreditasi
- Penerbitan SK dan sertifikat
- Sinkronisasi ke BANPT/PDDIKTI

## 🚀 Quick Start

```bash
# Clone repository
git clone <repository-url>
cd Saas_Blockchain_Lamtek

# Start semua container
docker-compose up -d

# Cek status
docker-compose ps
```

## 🔧 Konfigurasi

### Environment Variables
```bash
# .env
DATABASE_URL=mysql://user:password@localhost:3306/lamtek_db
BESU_RPC_URL=http://besu-node1:8545
IPFS_API_URL=http://ipfs-node:5001
JWT_SECRET=your-secret-key
```

## 📡 API Endpoints

### Akreditasi Reguler
- `POST /api/v1/akreditasi/registrasi` - Registrasi akreditasi
- `GET /api/v1/akreditasi/:id` - Detail akreditasi
- `POST /api/v1/akreditasi/:id/dokumen` - Upload dokumen
- `GET /api/v1/akreditasi/:id/status` - Status blockchain

### Asesmen Kecukupan
- `POST /api/v1/asesmen-kecukupan` - Buat asesmen kecukupan
- `PUT /api/v1/asesmen-kecukupan/:id/hasil` - Penetapan hasil

### Asesmen Lapangan
- `POST /api/v1/asesmen-lapangan` - Buat asesmen lapangan
- `PUT /api/v1/asesmen-lapangan/:id/jadwal` - Set jadwal visitasi
- `POST /api/v1/asesmen-lapangan/:id/laporan` - Submit laporan

## 🔐 Blockchain Features

- **Immutable Audit Trail**: Semua perubahan status akreditasi tercatat di blockchain
- **Smart Contracts**: Otomatisasi workflow akreditasi
- **IPFS Integration**: Penyimpanan dokumen terdistribusi
- **Multi-tenant**: Mendukung banyak institusi (SaaS)

## 📊 Database Schema

Lihat file `sakti_dummy_db.sql` untuk schema lengkap.

## 🛠️ Tech Stack

- **Backend**: Node.js + NestJS
- **Blockchain**: Hyperledger Besu (IBFT 2.0)
- **Storage**: IPFS
- **Database**: MySQL
- **Container**: Docker + Docker Compose
- **Smart Contracts**: Solidity

## 📄 License

Copyright © 2025 LAM Teknik
# Blockchain_lamtek
