# LAMTEK Docker & Feature Verification Report
**Tanggal:** 28 Juni 2026

## Ringkasan

| Komponen | Status | Catatan |
|----------|--------|---------|
| Smart Contract Tests (Hardhat) | ✅ PASS | 2/2 test lulus |
| Smart Contract Deploy (Hardhat) | ✅ PASS | 4 kontrak ter-deploy |
| Docker Compose Stack | ⚠️ BLOCKED | Docker daemon hang (beberapa `compose up` bersamaan) |
| Login / Register (live) | ⏳ Pending | Butuh stack Docker jalan |

---

## ✅ Smart Contracts — SUDAH DIVERIFIKASI

### Test Results
```
DokumenIPFSRegistry baseline
  ✔ sets deployer as owner and authorized signer
  ✔ uploads a document and increments totalDokumen

2 passing (2s)
```

### Deployed Contract Addresses (deterministic)
| Contract | Address |
|----------|---------|
| AkreditasiRegistry | `0x5FbDB2315678afecb367f032d93F642f64180aa3` |
| AsesmenKecukupanContract | `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512` |
| AsesmenLapanganContract | `0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0` |
| DokumenIPFSRegistry | `0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9` |

### Screenshots
- `screenshots/smart-contracts-screenshot.png` — Hasil test & daftar kontrak
- `screenshots/blockchain-network-screenshot.png` — Dashboard jaringan blockchain
- `screenshots/smart-contracts-report.html` — Laporan HTML interaktif

---

## ⚠️ Docker — Perlu Restart

Docker daemon (Colima) mengalami hang karena beberapa proses `docker compose up` berjalan bersamaan. Lakukan:

```bash
# 1. Restart Colima
colima stop && colima start

# 2. Jalankan stack (tanpa Blockscout dulu, lebih cepat)
cd /Users/HCMPublic/Kuliah/Blockchain_lamtek
docker compose up -d mysql redis zookeeper kafka ipfs-node besu-node1 besu-node2 besu-node3 besu-node4 api-gateway frontend

# 3. Deploy smart contract ke Besu
cd blockchain
BLOCKCHAIN_PRIVATE_KEY=0xc87509a1c067bbde78beb3e793fa12cc4337b340a66def355c14b0ab292efe4f \
BESU_RPC_URL=http://localhost:8545 \
npm run deploy

# 4. Tambahkan alamat kontrak ke .env root, lalu restart backend:
# AKREDITASI_CONTRACT_ADDRESS=0x...
# (copy dari output deploy)

docker compose restart api-gateway

# 5. Verifikasi semua fitur otomatis
./scripts/verify-docker-features.sh
```

---

## 🔐 Kredensial Test (Login)

| Email | Password | Role |
|-------|----------|------|
| admin@lamtek.test | Test1234! | ADMIN |
| sekretariat@lamtek.test | Test1234! | SEKRETARIAT |
| prodi@lamtek.test | Test1234! | PRODI |

Fallback (dari init SQL):
- `admin@lamtek.ac.id` / `password123`

---

## 🌐 URL Setelah Docker Jalan

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3002 |
| Backend API | http://localhost:3001/api/v1 |
| API Docs (Swagger) | http://localhost:3001/api/v1/docs |
| Besu RPC | http://localhost:8545 |
| IPFS Gateway | http://localhost:8888 |
| Kafka UI | http://localhost:8080 |

---

## Checklist Fitur Manual

Setelah Docker jalan, cek satu per satu:

- [ ] **Login** — http://localhost:3002/login dengan admin@lamtek.test
- [ ] **Register** — daftar user baru di halaman register
- [ ] **Dashboard** — statistik tampil tanpa error
- [ ] **Blockchain** — http://localhost:3002/dashboard/blockchain (network stats, transactions)
- [ ] **Dokumen** — upload & list dokumen
- [ ] **IPFS** — halaman IPFS dashboard
- [ ] **Akreditasi** — list & detail akreditasi
- [ ] **Registrasi** — form registrasi proses akreditasi
- [ ] **Smart Contract** — GET `/api/v1/blockchain/contracts` mengembalikan 4 alamat

### Test API cepat:
```bash
# Health
curl http://localhost:3001/api/v1/health

# Login
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lamtek.test","password":"Test1234!"}'

# Blockchain info (ganti TOKEN)
curl -H "Authorization: Bearer TOKEN" http://localhost:3001/api/v1/blockchain/stats
```
