#!/usr/bin/env bash
# Dump the full LAM Teknik database (schema + ALL data) into a single SQL file
# that can be loaded on any MySQL 8 instance — including PaaS.
#
# Usage:
#   scripts/db-dump.sh                # dump local DB on host port 3307
#   DB_HOST=db DB_PORT=3306 scripts/db-dump.sh
set -euo pipefail

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-3307}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-root123}"
DB_NAME="${DB_NAME:-lamtek_db}"
OUT_DIR="$(cd "$(dirname "$0")/.." && pwd)/backend/database/migration"
OUT_FILE="${OUT_DIR}/lamtek_db_full.sql"

mkdir -p "$OUT_DIR"
echo "Dumping ${DB_NAME} from ${DB_HOST}:${DB_PORT} -> ${OUT_FILE}"

# Run mysqldump from a throwaway container, writing straight to the mounted file
# (avoids relying on host<->container stdout streaming).
docker run --rm -v "${OUT_DIR}:/out" mysql:8.0 sh -c \
  "mysqldump -h ${DB_HOST} -P ${DB_PORT} -u${DB_USER} -p${DB_PASS} \
     --databases ${DB_NAME} \
     --add-drop-database --single-transaction --no-tablespaces --skip-comments \
     > /out/lamtek_db_full.sql"

echo "Done. $(grep -c 'CREATE TABLE' "$OUT_FILE") tables, $(grep -c 'INSERT INTO' "$OUT_FILE") insert statements."
