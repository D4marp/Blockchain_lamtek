#!/usr/bin/env bash
# Restore the full LAM Teknik database dump into a target MySQL 8 instance.
# Use this on the PaaS side (or any fresh environment) to migrate all data.
#
# Usage:
#   DB_HOST=paas-mysql DB_PORT=3306 DB_USER=root DB_PASS=secret scripts/db-restore.sh
set -euo pipefail

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-3307}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-root123}"
IN_DIR="$(cd "$(dirname "$0")/.." && pwd)/database/migration"
IN_FILE="${IN_DIR}/lamtek_db_full.sql"

[ -f "$IN_FILE" ] || { echo "Dump not found: $IN_FILE (run scripts/db-dump.sh first)"; exit 1; }
echo "Restoring ${IN_FILE} -> ${DB_HOST}:${DB_PORT}"

docker run --rm -v "${IN_DIR}:/in" mysql:8.0 sh -c \
  "mysql -h ${DB_HOST} -P ${DB_PORT} -u${DB_USER} -p${DB_PASS} < /in/lamtek_db_full.sql"

echo "Restore complete."
