#!/usr/bin/env bash
# Load schema fixups + seed users + demo data into running MySQL (Docker).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3307}"
DB_USER="${DB_USER:-lamtek}"
DB_PASS="${DB_PASS:-lamtek123}"
DB_NAME="${DB_NAME:-lamtek_db}"

run_sql() {
  local file="$1"
  echo "▶ $(basename "$file")"
  docker exec -i lamtek-mysql mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$file"
}

echo "============================================"
echo " LAMTEK — Setup Demo Data"
echo "============================================"

run_sql "$ROOT/backend/database/migration/01-schema-fixups.sql"
run_sql "$ROOT/backend/database/migration/02-seed-users.sql"

echo "▶ tenants (link institusi → tenant)"
docker exec -i lamtek-mysql mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" <<'SQL'
INSERT INTO tenants (id, institusi_id, nama, kode, is_active, blockchain_registered)
VALUES
  (1, 1, 'Institut Teknologi Sepuluh Nopember', 'ITS', 1, 0),
  (2, 2, 'Politeknik Elektronika Negeri Surabaya', 'PENS', 1, 0),
  (3, 3, 'Universitas Gadjah Mada', 'UGM', 1, 0)
ON DUPLICATE KEY UPDATE nama = VALUES(nama), is_active = 1;
SQL

run_sql "$ROOT/backend/database/migration/03-seed-demo-data.sql"
run_sql "$ROOT/backend/database/migration/04-seed-blockchain-transactions.sql"

echo ""
echo "✅ Demo data loaded."
echo "   Login: admin@lamtek.test / Test1234!"
echo "   Frontend: http://localhost:3003/login"
