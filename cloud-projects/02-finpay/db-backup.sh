#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/var/backups/postgresql"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
DB_NAME="postgres"
DB_USER="${DB_USER:-postgres}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.dump"

umask 077
mkdir -p "${BACKUP_DIR}"

pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -F c -f "${FILE}" "${DB_NAME}"

echo "Backup saved to ${FILE}"
