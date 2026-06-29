#!/usr/bin/env bash
# Test all LAMTEK API features after demo data migration.
set -uo pipefail

API="${API_URL:-http://localhost:3001/api/v1}"
PASS=0
FAIL=0

ok()  { echo "✅ $1"; PASS=$((PASS+1)); }
bad() { echo "❌ $1 — $2"; FAIL=$((FAIL+1)); }

login() {
  curl -sf -X POST "$API/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$1\",\"password\":\"$2\"}" 2>/dev/null
}

echo "============================================"
echo " LAMTEK Feature Test Suite"
echo "============================================"
echo ""

# Health
if curl -sf "$API/health" | grep -q '"status":"ok"'; then ok "Health check"; else bad "Health check" "no response"; fi

# Login — all roles
for cred in \
  "admin@lamtek.test:Test1234!:ADMIN" \
  "sekretariat@lamtek.test:Test1234!:SEKRETARIAT" \
  "komite@lamtek.test:Test1234!:KOMITE" \
  "majelis@lamtek.test:Test1234!:MAJELIS" \
  "asesor@lamtek.test:Test1234!:ASESOR" \
  "prodi@lamtek.test:Test1234!:PRODI" \
  "upps@lamtek.test:Test1234!:UPPS" \
  "validator@lamtek.test:Test1234!:VALIDATOR" \
  "admin@lamtek.ac.id:password123:ADMIN_LEGACY"; do
  IFS=: read -r email pw label <<< "$cred"
  resp=$(login "$email" "$pw")
  if echo "$resp" | grep -q '"token"'; then ok "Login $label ($email)"; else bad "Login $label" "$resp"; fi
done

TOKEN=$(login "admin@lamtek.test" "Test1234!" | python3 -c "import sys,json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)
AUTH="Authorization: Bearer $TOKEN"

# Register
REG_EMAIL="newuser_$(date +%s)@lamtek.test"
REG=$(curl -sf -X POST "$API/auth/register" -H "Content-Type: application/json" \
  -d "{\"name\":\"User Baru\",\"email\":\"$REG_EMAIL\",\"password\":\"Test1234!\"}" 2>/dev/null)
if echo "$REG" | grep -q '"token"'; then ok "Register new user"; else bad "Register" "$(echo "$REG" | head -c 120)"; fi

# Core endpoints
for ep in akreditasi dokumen tenant users dashboard/stats; do
  code=$(curl -sf -o /dev/null -w "%{http_code}" -H "$AUTH" "$API/$ep" 2>/dev/null || echo "000")
  if [ "$code" = "200" ]; then ok "GET /$ep"; else bad "GET /$ep" "HTTP $code"; fi
done

# Master data
for ep in master-data/institusi master-data/prodi master-data/asesor; do
  code=$(curl -sf -o /dev/null -w "%{http_code}" -H "$AUTH" "$API/$ep" 2>/dev/null || echo "000")
  if [ "$code" = "200" ]; then ok "GET /$ep"; else bad "GET /$ep" "HTTP $code"; fi
done

# Blockchain
BC=$(curl -sf -H "$AUTH" "$API/blockchain/contracts" 2>/dev/null)
if echo "$BC" | grep -q 'AkreditasiRegistry'; then ok "Blockchain contracts"; else bad "Blockchain contracts" "$BC"; fi

BC_INFO=$(curl -sf -H "$AUTH" "$API/blockchain/info" 2>/dev/null)
if echo "$BC_INFO" | grep -qE 'connected|chainId|blockNumber'; then ok "Blockchain info"; else bad "Blockchain info" "$BC_INFO"; fi

# Besu RPC
if curl -sf -X POST http://localhost:8545 -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | grep -q result; then
  ok "Besu RPC"
else
  bad "Besu RPC" "no response"
fi

# IPFS
if curl -sf -X POST http://localhost:5001/api/v0/version 2>/dev/null | grep -q Version; then ok "IPFS node"; else bad "IPFS node" "down"; fi

# Frontend
FE=$(curl -sf -o /dev/null -w "%{http_code}" http://localhost:3003/login 2>/dev/null || echo "000")
if [ "$FE" = "200" ]; then ok "Frontend /login"; else bad "Frontend" "HTTP $FE"; fi

echo ""
echo "============================================"
echo " Results: $PASS passed, $FAIL failed"
echo "============================================"
[ "$FAIL" -eq 0 ]
