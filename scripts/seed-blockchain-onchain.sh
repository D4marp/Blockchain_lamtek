#!/usr/bin/env bash
# Deploy smart contracts to Besu and register demo akreditasi (creates real on-chain txs).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BESU_RPC="${BESU_RPC_URL:-http://localhost:8545}"
# Besu genesis pre-funded validator key (dev only)
PK="${BLOCKCHAIN_PRIVATE_KEY:-0xc87509a1c067bbde78beb3e793fa12cc4337b340a66def355c14b0ab292efe4f}"

echo "============================================"
echo " Deploy + Seed Blockchain (Besu)"
echo "============================================"

cd "$ROOT/blockchain"

echo "▶ Deploying contracts to Besu..."
BLOCKCHAIN_PRIVATE_KEY="$PK" BESU_RPC_URL="$BESU_RPC" npx hardhat run scripts/deploy.js --network besu

DEP_FILE="$ROOT/blockchain/deployments/besu-deployment.json"
if [ ! -f "$DEP_FILE" ]; then
  echo "Deployment file not found: $DEP_FILE"
  exit 1
fi

AKR=$(python3 -c "import json; print(json.load(open('$DEP_FILE'))['contracts']['AkreditasiRegistry'])")
AK=$(python3 -c "import json; print(json.load(open('$DEP_FILE'))['contracts']['AsesmenKecukupanContract'])")
AL=$(python3 -c "import json; print(json.load(open('$DEP_FILE'))['contracts']['AsesmenLapanganContract'])")
DOC=$(python3 -c "import json; print(json.load(open('$DEP_FILE'))['contracts']['DokumenIPFSRegistry'])")

echo ""
echo "Contract addresses:"
echo "  AKREDITASI_CONTRACT_ADDRESS=$AKR"
echo "  ASESMEN_KECUKUPAN_CONTRACT_ADDRESS=$AK"
echo "  ASESMEN_LAPANGAN_CONTRACT_ADDRESS=$AL"
echo "  DOKUMEN_IPFS_CONTRACT_ADDRESS=$DOC"

echo "▶ Registering tenants + akreditasi on-chain..."
BLOCKCHAIN_PRIVATE_KEY="$PK" BESU_RPC_URL="$BESU_RPC" npx hardhat run scripts/register-seed.js --network besu

echo ""
echo "▶ Update docker-compose contract env and restart API:"
echo "  docker compose up -d api-gateway"
echo ""
echo "✅ On-chain seed complete. Refresh /dashboard/blockchain"
