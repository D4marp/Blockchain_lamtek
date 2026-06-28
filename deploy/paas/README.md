# Deploy ke PaaS (Docker Swarm) — 4 Microservice Terpisah

Panduan memecah aplikasi menjadi **4 service** yang di-push satu per satu ke PaaS
berbasis Docker Swarm, **tanpa hardcode** — semua koneksi lewat ENV.

```
SERVICE 1  blockchain  (Hardhat 1 node, auto-deploy kontrak saat start)
SERVICE 2  kafka       (Kafka + Zookeeper)
SERVICE 3  backend     (NestJS — hub: konek ke blockchain, kafka, mysql, redis, ipfs)
SERVICE 4  frontend    (Next.js)
```

> Backend juga butuh **MySQL, Redis, IPFS**. Di Swarm ini ikut di *backend-stack*
> (data tier privat backend). Kalau PaaS menyediakan MySQL/Redis sebagai add-on
> terkelola, cukup ganti host di `backend.env` — tidak ada yang di-hardcode di kode.

---

## 1. Peta koneksi (siapa mengarah ke mana)

| Dari → Ke              | Variabel ENV                          | Nilai (overlay Swarm)              | Sifat        |
|------------------------|---------------------------------------|------------------------------------|--------------|
| Browser → Frontend     | (URL publik PaaS)                     | `http://frontend_lamtek.paas...`   | publik       |
| Browser → Backend API  | `NEXT_PUBLIC_API_URL`                 | `http://backend_lamtek.paas.../api/v1` | **build-time** |
| Browser → IPFS gateway | `NEXT_PUBLIC_IPFS_GATEWAY`            | `http://ipfs_lamtek.paas...`       | **build-time** |
| Frontend(server)→Backend | `BACKEND_INTERNAL_URL`              | `http://backend:3000`              | runtime      |
| Backend → Blockchain   | `BESU_RPC_URL`, `EXTERNAL_SIGNER_RPC_URL` | `http://blockchain:8545`       | runtime      |
| Backend → Kafka        | `KAFKA_BROKERS`                       | `kafka:9092`                       | runtime      |
| Backend → MySQL        | `DB_HOST` / `DATABASE_URL`            | `mysql:3306`                       | runtime      |
| Backend → Redis        | `REDIS_URL`                           | `redis://redis:6379`               | runtime      |
| Backend → IPFS API     | `IPFS_API_URL`                        | `http://ipfs:5001`                 | runtime      |
| Kafka (advertise)      | `KAFKA_ADVERTISED_LISTENERS`          | `PLAINTEXT://kafka:9092`           | runtime      |

**Aturan emas:** nama host = nama service di overlay network bersama. Tidak ada
IP/host yang ditulis di kode — semuanya dari ENV di tabel ini.

---

## 2. Tiga jebakan paling sering (WAJIB paham)

1. **`NEXT_PUBLIC_*` di frontend itu BUILD-TIME, bukan runtime.**
   Nilai di-*inline* saat `npm run build`. Mengubahnya = **rebuild image**, bukan
   sekadar restart. Karena itu dikirim sebagai `build.args` di `frontend-stack.yml`.
   `NEXT_PUBLIC_API_URL` & `NEXT_PUBLIC_IPFS_GATEWAY` harus **hostname PUBLIK**
   (yang diakses browser), bukan nama service internal.

2. **Kafka `KAFKA_ADVERTISED_LISTENERS` harus sama persis dengan `KAFKA_BROKERS` backend.**
   Klien konek dulu ke broker, lalu broker membalas alamat *advertised* dan klien
   reconnect ke situ. Kalau advertise `localhost`/`kafka` tapi backend tak bisa
   resolve nama itu → handshake gagal. Di overlay bersama: advertise `kafka:9092`.

3. **Blockchain Hardhat reset tiap restart.** Entrypoint sudah auto-deploy kontrak
   saat boot, sehingga address tetap deterministik:
   `0x5FbDB2…`, `0xe7f17…`, `0x9fE46…`, `0xCf7Ed3…` (sudah diisi di `backend.env`).

---

## 3. Urutan deploy di Docker Swarm

```bash
# 0) Buat SATU overlay network bersama (sekali saja, di manager node)
docker network create --driver overlay --attachable lamtek-net

# 1) Build & push tiap image ke registry PaaS (ganti REGISTRY)
docker build -t REGISTRY/lamtek-blockchain ./blockchain && docker push REGISTRY/lamtek-blockchain
docker build -t REGISTRY/lamtek-backend    ./backend    && docker push REGISTRY/lamtek-backend
# Frontend HARUS dibangun dengan build-args publik (lihat catatan di bawah):
docker build -t REGISTRY/lamtek-frontend ./frontend \
  --build-arg NEXT_PUBLIC_API_URL=http://backend_lamtek.paas.hcm-lab.id/api/v1 \
  --build-arg NEXT_PUBLIC_IPFS_GATEWAY=http://ipfs_lamtek.paas.hcm-lab.id \
  --build-arg NEXT_PUBLIC_FRONTEND_URL=http://frontend_lamtek.paas.hcm-lab.id
docker push REGISTRY/lamtek-frontend

# 2) Deploy stack per service (one-by-one). Muat ENV ke shell dulu karena
#    `docker stack deploy` MENGABAIKAN env_file — ia hanya interpolasi ${VAR}.
set -a; . deploy/paas/blockchain.env; set +a; docker stack deploy -c deploy/paas/blockchain-stack.yml blockchain
set -a; . deploy/paas/kafka.env;      set +a; docker stack deploy -c deploy/paas/kafka-stack.yml      kafka
set -a; . deploy/paas/backend.env;    set +a; docker stack deploy -c deploy/paas/backend-stack.yml    backend
set -a; . deploy/paas/frontend.env;   set +a; docker stack deploy -c deploy/paas/frontend-stack.yml   frontend
```

> Kalau PaaS punya UI sendiri untuk push per-service: gunakan tiap `*.env.example`
> sebagai daftar ENV yang harus diisi di panel, dan pastikan semua service
> disambungkan ke network `lamtek-net`.

## 3b. Hasil uji lokal (sudah diverifikasi via Dockerfile)

Keempat image **build & run** dan saling terhubung lewat ENV:
- ✅ blockchain: node start + auto-deploy 4 kontrak ke address deterministik.
- ✅ kafka: broker KRaft up; image **auto-create 29 topik** backend saat start
  (lihat `kafka/create-topics.sh`). Tanpa ini consumer NestJS crash di broker baru
  (`This server does not host this topic-partition`).
- ✅ backend: konek MySQL ✓, Blockchain ✓ (4 kontrak ter-load), Kafka consumer
  join group ✓, `/api/v1/health` → `{"status":"ok"}`.
- ✅ frontend: serve HTTP 200; `NEXT_PUBLIC_API_URL` publik ter-bake di bundle.

**Catatan skema DB:** semua tabel adalah entity TypeORM dan **tidak ada migration**,
jadi skema dibangun via `TYPEORM_SYNCHRONIZE=true` (sudah default). Script
`database/init/*.sql` TIDAK dipakai (incomplete + ada VIEW yang menggagalkan init
di DB fresh). `npm run seed` memakai DataSource `synchronize:false`, jadi seed
hanya jalan setelah tabel ada — untuk demo set `SEED_ON_STARTUP=false` bila perlu.

## 4. Checklist sebelum produksi
- [ ] Ganti `JWT_SECRET`, password MySQL.
- [ ] `CORS_ORIGINS` di backend = origin publik frontend (jangan ada `localhost`).
- [ ] Frontend di-build ulang setiap `NEXT_PUBLIC_*` berubah.
- [ ] Semua 4 service tergabung di network `lamtek-net`.
