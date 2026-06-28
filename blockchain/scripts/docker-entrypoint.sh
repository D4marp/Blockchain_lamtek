#!/bin/sh
# ---------------------------------------------------------------------------
# Blockchain service entrypoint (Hardhat single node) for PaaS / Docker Swarm.
#
# Hardhat's `node` keeps state in-memory, so it resets on every restart. This
# script starts the node, waits for the JSON-RPC port to come up, then deploys
# the contracts. Because account #0 deploys the same 4 contracts in the same
# order on a fresh chain, the resulting addresses are DETERMINISTIC and match
# the *_CONTRACT_ADDRESS values configured for the backend:
#   AkreditasiRegistry     0x5FbDB2315678afecb367f032d93F642f64180aa3
#   AsesmenKecukupan       0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
#   AsesmenLapangan        0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
#   DokumenIPFSRegistry    0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
# ---------------------------------------------------------------------------
set -e

RPC_HOST="${RPC_HOST:-0.0.0.0}"
RPC_PORT="${RPC_PORT:-8545}"
DEPLOY_ON_START="${DEPLOY_ON_START:-true}"
RUN_SEED="${RUN_SEED:-false}"
ENABLE_IPFS="${ENABLE_IPFS:-true}"

# ---------------------------------------------------------------------------
# IPFS (kubo) — digabung dalam container yang sama dengan blockchain.
# API di :5001 dan Gateway di :8080 di-bind ke 0.0.0.0 agar backend (container
# lain) bisa mengakses. Backend memakai IPFS_API_URL=http://blockchain:5001.
# ---------------------------------------------------------------------------
if [ "$ENABLE_IPFS" = "true" ]; then
  export IPFS_PATH="${IPFS_PATH:-/app/.ipfs}"
  if [ ! -f "$IPFS_PATH/config" ]; then
    echo "[ipfs] init repo di $IPFS_PATH ..."
    ipfs init --profile server >/dev/null 2>&1 || ipfs init >/dev/null 2>&1
  fi
  ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001 >/dev/null 2>&1 || true
  ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080 >/dev/null 2>&1 || true
  echo "[ipfs] starting daemon (API :5001, Gateway :8080) ..."
  ipfs daemon --migrate=true --enable-gc &
fi

echo "[blockchain] starting hardhat node on ${RPC_HOST}:${RPC_PORT} ..."
npx hardhat node --hostname "${RPC_HOST}" --port "${RPC_PORT}" &
NODE_PID=$!

# Wait for the RPC endpoint to accept connections (max ~60s)
echo "[blockchain] waiting for JSON-RPC ..."
i=0
until node -e "fetch('http://127.0.0.1:${RPC_PORT}',{method:'POST',headers:{'content-type':'application/json'},body:'{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_blockNumber\",\"params\":[]}'}).then(r=>r.ok?process.exit(0):process.exit(1)).catch(()=>process.exit(1))" 2>/dev/null; do
  i=$((i+1))
  if [ "$i" -ge 30 ]; then
    echo "[blockchain] RPC did not come up in time" >&2
    kill "$NODE_PID" 2>/dev/null || true
    exit 1
  fi
  sleep 2
done
echo "[blockchain] JSON-RPC is up."

if [ "$DEPLOY_ON_START" = "true" ]; then
  echo "[blockchain] deploying contracts (network=localhost) ..."
  npx hardhat run scripts/deploy.js --network localhost
  echo "[blockchain] contracts deployed."

  if [ "$RUN_SEED" = "true" ]; then
    echo "[blockchain] seeding registry ..."
    npx hardhat run scripts/register-seed.js --network localhost || echo "[blockchain] seed step failed (non-fatal)"
  fi
fi

echo "[blockchain] node ready. Tailing node process (pid ${NODE_PID})."
wait "$NODE_PID"
