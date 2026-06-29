# LAMTEK — Siap Digunakan

## URL Aplikasi

| Layanan | URL |
|---------|-----|
| **Login / Dashboard** | http://localhost:3003/login |
| **API Backend** | http://localhost:3001/api/v1 |
| **Swagger Docs** | http://localhost:3001/api/docs |
| **Blockchain RPC (Besu)** | http://localhost:8545 |
| **IPFS Gateway** | http://localhost:8888 |

## Akun Login (password semua: `Test1234!`)

| Email | Role | Kegunaan |
|-------|------|----------|
| admin@lamtek.test | ADMIN | Akses penuh sistem |
| sekretariat@lamtek.test | SEKRETARIAT | Operasional sekretariat |
| komite@lamtek.test | KOMITE_EVALUASI | Komite evaluasi |
| majelis@lamtek.test | MAJELIS_AKREDITASI | Keputusan akreditasi |
| asesor@lamtek.test | ASESOR | Asesmen lapangan/kecukupan |
| prodi@lamtek.test | PRODI | Pengajuan akreditasi prodi |
| upps@lamtek.test | UPPS | Unit pengelola program studi |
| validator@lamtek.test | VALIDATOR | Validasi registrasi |

**Akun legacy:** `admin@lamtek.ac.id` / `password123`

## Data Demo yang Sudah Dimuat

| Data | Jumlah |
|------|--------|
| Institusi | 3 (ITS, PENS, UGM) |
| Program Studi | 6 |
| Asesor | 5 |
| Akreditasi | 10 (semua tahapan workflow) |
| On Blockchain | 6 record |
| Pembayaran | 4 |
| Penawaran Asesor | 5 |
| Asesmen Kecukupan | 4 |
| Asesmen Lapangan | 4 |
| Keputusan MA | 2 |

## Smart Contracts

| Contract | Address |
|----------|---------|
| AkreditasiRegistry | `0x5FbDB2315678afecb367f032d93F642f64180aa3` |
| AsesmenKecukupan | `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512` |
| AsesmenLapangan | `0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0` |
| DokumenIPFSRegistry | `0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9` |

## Blockchain Transactions

```bash
# Seed 12 transaksi demo ke database (audit trail)
docker exec -i lamtek-mysql mysql -ulamtek -plamtek123 lamtek_db < database/migration/04-seed-blockchain-transactions.sql

# (Opsional) Deploy kontrak + register akreditasi di Besu — transaksi on-chain nyata
./scripts/seed-blockchain-onchain.sh

# Restart API setelah update backend
docker compose up -d --build api-gateway frontend
```

Dashboard blockchain: http://localhost:3003/dashboard/blockchain

```bash
# Jalankan stack Docker
docker compose up -d

# Muat ulang data demo
./scripts/setup-demo-data.sh

# Tes semua fitur
./scripts/test-all-features.sh

# Tes smart contract
cd blockchain && npm test
```

## Halaman Dashboard Utama

- Dashboard: `/dashboard`
- Akreditasi: `/dashboard/akreditasi`
- Registrasi: `/dashboard/registrasi`
- Dokumen: `/dashboard/dokumen`
- Blockchain: `/dashboard/blockchain`
- IPFS: `/dashboard/ipfs`
- Users: `/dashboard/users`
- Master Data Institusi: `/dashboard/master-data/institusi`
