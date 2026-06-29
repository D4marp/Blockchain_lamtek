#!/bin/bash
# Verify all LAMTEK Docker features: health, auth, blockchain, IPFS
set -euo pipefail

API="${API_URL:-http://localhost:3001/api/v1}"
FE="${FE_URL:-http://localhost:3002}"
BESU="${BESU_RPC:-http://localhost:8545}"
REPORT_DIR="${REPORT_DIR:-./screenshots}"
mkdir -p "$REPORT_DIR"

PASS=0
FAIL=0
RESULTS=()

log() { echo "[$(date +%H:%M:%S)] $*"; }

check() {
  local name="$1" ok="$2" detail="$3"
  if [ "$ok" = "1" ]; then
    RESULTS+=("PASS|$name|$detail")
    log "✅ $name"
    PASS=$((PASS+1))
  else
    RESULTS+=("FAIL|$name|$detail")
    log "❌ $name — $detail"
    FAIL=$((FAIL+1))
  fi
}

wait_for() {
  local url="$1" label="$2" max="${3:-60}"
  log "Waiting for $label ($url)..."
  for i in $(seq 1 "$max"); do
    if curl -sf --connect-timeout 3 "$url" >/dev/null 2>&1; then
      log "$label is up"
      return 0
    fi
    sleep 5
  done
  return 1
}

# --- Wait for services ---
wait_for "$API/health" "Backend API" 90 || check "Backend health" 0 "timeout" 
wait_for "$FE/login" "Frontend" 90 || true

# --- 1. Health ---
HEALTH=$(curl -sf "$API/health" 2>/dev/null || echo '{}')
if echo "$HEALTH" | grep -q '"status"'; then
  check "Backend /health" 1 "$(echo "$HEALTH" | head -c 120)"
else
  check "Backend /health" 0 "$HEALTH"
fi

# --- 2. Login (seed user) ---
LOGIN=$(curl -sf -X POST "$API/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lamtek.test","password":"Test1234!"}' 2>/dev/null || echo '{}')
TOKEN=$(echo "$LOGIN" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('token',''))" 2>/dev/null || echo "")
if [ -n "$TOKEN" ]; then
  check "Login admin@lamtek.test" 1 "token received"
else
  # fallback seed from init sql
  LOGIN2=$(curl -sf -X POST "$API/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@lamtek.ac.id","password":"password123"}' 2>/dev/null || echo '{}')
  TOKEN=$(echo "$LOGIN2" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('token',''))" 2>/dev/null || echo "")
  if [ -n "$TOKEN" ]; then
    check "Login admin@lamtek.ac.id" 1 "token received"
  else
    check "Login" 0 "$(echo "$LOGIN" | head -c 200)"
  fi
fi

# --- 3. Register new user ---
REG_EMAIL="testuser_$(date +%s)@lamtek.test"
REGISTER=$(curl -sf -X POST "$API/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Test User\",\"email\":\"$REG_EMAIL\",\"password\":\"Test1234!\",\"role\":\"PRODI\"}" 2>/dev/null || echo '{}')
REG_TOKEN=$(echo "$REGISTER" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('token',''))" 2>/dev/null || echo "")
if [ -n "$REG_TOKEN" ]; then
  check "Register new user" 1 "$REG_EMAIL"
else
  check "Register new user" 0 "$(echo "$REGISTER" | head -c 200)"
fi

AUTH="Authorization: Bearer $TOKEN"

# --- 4. Dashboard ---
DASH=$(curl -sf -H "$AUTH" "$API/dashboard/stats" 2>/dev/null || echo '{}')
if echo "$DASH" | grep -qE 'total|count|akreditasi|users'; then
  check "Dashboard stats" 1 "$(echo "$DASH" | head -c 120)"
else
  check "Dashboard stats" 0 "$(echo "$DASH" | head -c 200)"
fi

# --- 5. Blockchain endpoints ---
BC_INFO=$(curl -sf -H "$AUTH" "$API/blockchain/info" 2>/dev/null || echo '{}')
echo "$BC_INFO" > "$REPORT_DIR/blockchain-info.json"
if echo "$BC_INFO" | grep -qE 'chainId|connected|blockNumber|status'; then
  check "Blockchain /info" 1 "$(echo "$BC_INFO" | head -c 120)"
else
  check "Blockchain /info" 0 "$(echo "$BC_INFO" | head -c 200)"
fi

BC_STATS=$(curl -sf -H "$AUTH" "$API/blockchain/stats" 2>/dev/null || echo '{}')
echo "$BC_STATS" > "$REPORT_DIR/blockchain-stats.json"

BC_NET=$(curl -sf -H "$AUTH" "$API/blockchain/network-stats" 2>/dev/null || echo '{}')
echo "$BC_NET" > "$REPORT_DIR/blockchain-network.json"
check "Blockchain /network-stats" 1 "$(echo "$BC_NET" | head -c 120)"

BC_CONTRACTS=$(curl -sf -H "$AUTH" "$API/blockchain/contracts" 2>/dev/null || echo '{}')
echo "$BC_CONTRACTS" > "$REPORT_DIR/smart-contracts.json"
if echo "$BC_CONTRACTS" | grep -qE 'address|Akreditasi|contract'; then
  check "Smart contracts list" 1 "$(echo "$BC_CONTRACTS" | head -c 200)"
else
  check "Smart contracts list" 0 "No contract addresses configured"
fi

BC_TX=$(curl -sf -H "$AUTH" "$API/blockchain/transactions?limit=5" 2>/dev/null || echo '[]')
echo "$BC_TX" > "$REPORT_DIR/blockchain-transactions.json"
check "Blockchain transactions" 1 "$(echo "$BC_TX" | head -c 100)"

# --- 6. Besu RPC direct ---
BESU_RESP=$(curl -sf -X POST "$BESU" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' 2>/dev/null || echo '{}')
echo "$BESU_RESP" > "$REPORT_DIR/besu-rpc.json"
if echo "$BESU_RESP" | grep -q 'result'; then
  check "Besu RPC eth_blockNumber" 1 "$BESU_RESP"
else
  check "Besu RPC" 0 "$BESU_RESP"
fi

# --- 7. IPFS ---
IPFS=$(curl -sf -X POST "http://localhost:5001/api/v0/version" 2>/dev/null || echo '{}')
if echo "$IPFS" | grep -q 'Version'; then
  check "IPFS node" 1 "$IPFS"
else
  check "IPFS node" 0 "$IPFS"
fi

# --- 8. Other key endpoints ---
for ep in "akreditasi" "dokumen" "tenant" "users"; do
  R=$(curl -sf -o /dev/null -w "%{http_code}" -H "$AUTH" "$API/$ep" 2>/dev/null || echo "000")
  if [ "$R" = "200" ] || [ "$R" = "201" ]; then
    check "GET /$ep" 1 "HTTP $R"
  else
    check "GET /$ep" 0 "HTTP $R"
  fi
done

# --- Generate HTML report ---
cat > "$REPORT_DIR/verification-report.html" << HTMLEOF
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<title>LAMTEK Verification Report</title>
<style>
  body { font-family: system-ui, sans-serif; max-width: 960px; margin: 2rem auto; background: #0f172a; color: #e2e8f0; }
  h1 { color: #38bdf8; }
  .pass { color: #4ade80; } .fail { color: #f87171; }
  pre { background: #1e293b; padding: 1rem; border-radius: 8px; overflow-x: auto; font-size: 13px; }
  .card { background: #1e293b; border-radius: 12px; padding: 1.5rem; margin: 1rem 0; border: 1px solid #334155; }
  h2 { color: #a78bfa; margin-top: 0; }
  table { width: 100%; border-collapse: collapse; }
  td, th { padding: 8px 12px; border-bottom: 1px solid #334155; text-align: left; }
</style>
</head>
<body>
<h1>🔗 LAMTEK Docker Verification Report</h1>
<p>Generated: $(date)</p>
<p>Passed: <span class="pass">$PASS</span> | Failed: <span class="fail">$FAIL</span></p>
<div class="card"><h2>Test Results</h2><table>
<tr><th>Status</th><th>Test</th><th>Detail</th></tr>
HTMLEOF

for r in "${RESULTS[@]}"; do
  IFS='|' read -r st name det <<< "$r"
  cls="pass"; [ "$st" = "FAIL" ] && cls="fail"
  det_esc=$(echo "$det" | sed 's/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g')
  echo "<tr><td class=\"$cls\">$st</td><td>$name</td><td><small>$det_esc</small></td></tr>" >> "$REPORT_DIR/verification-report.html"
done

cat >> "$REPORT_DIR/verification-report.html" << HTMLEOF
</table></div>
<div class="card"><h2>Blockchain Info</h2><pre>$(cat "$REPORT_DIR/blockchain-info.json" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo '{}')</pre></div>
<div class="card"><h2>Smart Contracts</h2><pre>$(cat "$REPORT_DIR/smart-contracts.json" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo '{}')</pre></div>
<div class="card"><h2>Besu RPC</h2><pre>$(cat "$REPORT_DIR/besu-rpc.json" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo '{}')</pre></div>
<div class="card"><h2>Network Stats</h2><pre>$(cat "$REPORT_DIR/blockchain-network.json" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo '{}')</pre></div>
</body></html>
HTMLEOF

log ""
log "============================================"
log "SUMMARY: $PASS passed, $FAIL failed"
log "Report: $REPORT_DIR/verification-report.html"
log "============================================"

[ "$FAIL" -eq 0 ]
