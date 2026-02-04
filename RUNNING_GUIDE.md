# 🚀 LAM TEKNIK SAAS BLOCKCHAIN - Panduan Menjalankan Sistem

## 📊 **Arsitektur Services:**

| Service | Container | Port | URL/Endpoint |
|---------|-----------|------|--------------|
| **API Gateway (NestJS)** | lamtek-api-gateway | 3001 | http://localhost:3001 |
| **Frontend (Next.js)** | - | 3000 | http://localhost:3000 |
| **Besu Node 1 (Validator)** | lamtek-besu-node1 | 8545 | http://localhost:8545 |
| **Besu Node 2 (Validator)** | lamtek-besu-node2 | 8555 | http://localhost:8555 |
| **Besu Node 3 (Validator)** | lamtek-besu-node3 | 8565 | http://localhost:8565 |
| **Besu Node 4 (Validator)** | lamtek-besu-node4 | 8575 | http://localhost:8575 |
| **IPFS Node** | lamtek-ipfs-node | 5001, 8888 | http://localhost:5001 |
| **Kafka** | lamtek-kafka | 9092, 29092 | localhost:29092 |
| **Kafka UI** | lamtek-kafka-ui | 8080 | http://localhost:8080 |
| **Zookeeper** | lamtek-zookeeper | 2181 | localhost:2181 |
| **MySQL Database** | lamtek-mysql | 3306 | localhost:3306 |
| **Redis Cache** | lamtek-redis | 6379 | localhost:6379 |
| **BlockScout Explorer** | lamtek-blockscout | 4000 | http://localhost:4000 |

---

## 🏗️ **Arsitektur Blockchain:**

```
┌─────────────────────────────────────────────────────────────────┐
│                    LAM Teknik Blockchain Network                 │
│                         (IBFT 2.0 Consensus)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐     │
│   │   Node 1     │    │   Node 2     │    │   Node 3     │     │
│   │  (Bootnode)  │◄──►│  (Validator) │◄──►│  (Validator) │     │
│   │  Validator   │    │              │    │              │     │
│   │  :8545       │    │  :8555       │    │  :8565       │     │
│   └──────┬───────┘    └──────────────┘    └──────────────┘     │
│          │                    ▲                   ▲             │
│          │                    │                   │             │
│          ▼                    ▼                   ▼             │
│   ┌──────────────┐                                              │
│   │   Node 4     │◄─────────────────────────────────────────   │
│   │  (Validator) │                                              │
│   │  :8575       │                                              │
│   └──────────────┘                                              │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│  Chain ID: 1337 │ Block Time: 2s │ Consensus: IBFT 2.0          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📨 **Kafka Event Streaming:**

### Topics:
| Topic | Description |
|-------|-------------|
| `lamtek.blockchain.transaction` | Blockchain transaction events |
| `lamtek.blockchain.contract.event` | Smart contract events |
| `lamtek.akreditasi.created` | New akreditasi registration |
| `lamtek.akreditasi.status.changed` | Status change events |
| `lamtek.document.uploaded` | Document upload events |
| `lamtek.document.ipfs.stored` | IPFS storage confirmation |
| `lamtek.payment.completed` | Payment completion |
| `lamtek.notification.email` | Email notifications |
| `lamtek.audit.log` | Audit trail |

---

## 🚀 **Quick Start:**

### 1. Setup Network (First Time)
```bash
cd blockchain/besu
chmod +x setup-network.sh
./setup-network.sh
```

### 2. Start All Services
```bash
cd /path/to/Saas_Blockchain_Lamtek
docker-compose up -d
```

### 3. Check Services Status
```bash
docker-compose ps
```

### 4. Start Backend (Development)
```bash
cd backend
npm run start:dev
```

### 5. Start Frontend (Development)
```bash
cd frontend
npm run dev
```

---

## 🔐 **Demo Login Credentials:**

### Admin LAM Teknik
```
Email: admin@lamtek.ac.id
Password: password123
Role: ADMIN
```

### PT Institusi Teknik (Koordinator)
```
Email: koordinator@ui.ac.id
Password: password123
Role: INSTITUTION
```

### Validator
```
Email: validator@lamtek.ac.id
Password: password123
Role: VALIDATOR
```

### Asesor
```
Email: asesor@lamtek.ac.id
Password: password123
Role: ASSESSOR
```

---

## 🔧 **Useful Commands:**

### Docker
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Restart specific service
docker-compose restart besu-node1

# Check Besu nodes
docker-compose logs besu-node1 besu-node2 besu-node3 besu-node4

# Check Kafka
docker-compose logs kafka
```

### Blockchain
```bash
# Check block number on Node 1
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545

# Check peer count
curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545

# Check validators
curl -X POST --data '{"jsonrpc":"2.0","method":"ibft_getValidatorsByBlockNumber","params":["latest"],"id":1}' http://localhost:8545
```

### Kafka
```bash
# List topics
docker exec lamtek-kafka kafka-topics --bootstrap-server localhost:9092 --list

# Create topic
docker exec lamtek-kafka kafka-topics --bootstrap-server localhost:9092 --create --topic lamtek.test --partitions 1 --replication-factor 1

# Consume messages
docker exec lamtek-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic lamtek.blockchain.transaction --from-beginning
```

### IPFS
```bash
# Check IPFS status
curl http://localhost:5001/api/v0/id

# Add file to IPFS
curl -X POST -F file=@yourfile.pdf http://localhost:5001/api/v0/add

# Get file from IPFS
curl http://localhost:8888/ipfs/YOUR_HASH
```

---

## 📁 **Project Structure:**

```
Saas_Blockchain_Lamtek/
├── backend/                 # NestJS API Gateway
│   ├── src/
│   │   ├── modules/
│   │   │   ├── akreditasi/
│   │   │   ├── asesmen-kecukupan/
│   │   │   ├── asesmen-lapangan/
│   │   │   ├── auth/
│   │   │   ├── blockchain/
│   │   │   ├── dokumen/
│   │   │   ├── health/
│   │   │   ├── ipfs/
│   │   │   ├── kafka/          # NEW: Kafka event streaming
│   │   │   ├── master-data/
│   │   │   ├── pembayaran/
│   │   │   ├── proses-akreditasi/
│   │   │   ├── tenant/
│   │   │   └── users/
│   │   └── app.module.ts
│   └── package.json
├── frontend/                # Next.js Frontend
│   ├── src/
│   │   ├── app/
│   │   ├── components/
│   │   ├── lib/
│   │   │   ├── api.ts         # API service
│   │   │   └── hooks.ts       # React hooks
│   │   └── types/
│   └── package.json
├── blockchain/              # Besu Network
│   ├── besu/
│   │   ├── genesis.json       # 4-validator IBFT 2.0
│   │   ├── config.toml
│   │   ├── static-nodes.json
│   │   ├── setup-network.sh
│   │   ├── node1/
│   │   ├── node2/
│   │   ├── node3/
│   │   └── node4/
│   └── contracts/
├── ipfs/                    # IPFS data
├── database/                # Database volumes
└── docker-compose.yml       # All services config
```

---

## 🌐 **API Endpoints:**

### Authentication
- `POST /auth/login` - Login
- `POST /auth/register` - Register
- `GET /auth/me` - Get current user
- `POST /auth/logout` - Logout

### Master Data
- `GET/POST /master-data/institusi` - Institutions
- `GET/POST /master-data/prodi` - Study Programs
- `GET/POST /master-data/asesor` - Assessors
- `GET/POST /master-data/upps` - UPPS
- ... (see API.md for full list)

### Proses Akreditasi
- `GET/POST /proses-akreditasi/penawaran-asesor`
- `GET/POST /proses-akreditasi/respon-asesor`
- `GET/POST /proses-akreditasi/laporan-asesmen`
- ... (see API.md for full list)

### Blockchain
- `POST /blockchain/register-akreditasi`
- `GET /blockchain/verify/:hash`
- `GET /blockchain/tx/:txHash`

### IPFS
- `POST /ipfs/upload`
- `GET /ipfs/:hash`

---

## 🔍 **Monitoring:**

| Dashboard | URL | Description |
|-----------|-----|-------------|
| Kafka UI | http://localhost:8080 | Kafka topics & messages |
| BlockScout | http://localhost:4000 | Blockchain explorer |
| Besu Metrics | http://localhost:9545/metrics | Node 1 Prometheus metrics |

---

## ⚠️ **Troubleshooting:**

### Besu nodes not syncing
```bash
# Check peer connections
docker exec lamtek-besu-node1 curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' http://localhost:8545

# Restart all nodes
docker-compose restart besu-node1 besu-node2 besu-node3 besu-node4
```

### Kafka not connecting
```bash
# Check Zookeeper
docker exec lamtek-zookeeper nc -z localhost 2181

# Check Kafka logs
docker-compose logs kafka
```

### IPFS not responding
```bash
# Check IPFS daemon
docker exec lamtek-ipfs-node ipfs id

# Restart IPFS
docker-compose restart ipfs-node
```

---

## 📝 **Notes:**

1. **IBFT 2.0 Consensus**: Membutuhkan minimal 4 validator untuk Byzantine Fault Tolerance (dapat mentoleransi 1 node gagal)
2. **Kafka**: Semua blockchain events di-stream melalui Kafka untuk async processing
3. **IPFS**: Dokumen disimpan di IPFS dengan hash di-register ke blockchain
4. **Block Time**: 2 detik per block
5. **Gas Price**: 0 (private network, no gas fees)
