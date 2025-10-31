#!/bin/bash
set -euo pipefail

# Configuration
export GDRIVE_REMOTE="gdrive:fulcrum_backups"
export BACKUP_DIR="/tmp/fulcrum_backups"
export PG_DATABASE="app_db"
export PG_HOST="localhost"
export PG_USER="postgres"
# PG_PASSWORD should be set as an environment variable in Coolify

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup Postgres
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
PG_DUMP_FILE="$BACKUP_DIR/postgres-$TIMESTAMP.sql.gz"
echo "Dumping database to $PG_DUMP_FILE..."
pg_dump -h "$PG_HOST" -U "$PG_USER" -d "$PG_DATABASE" | gzip > "$PG_DUMP_FILE"

# Backup Coolify volumes (example)
# tar -czf "$BACKUP_DIR/coolify-data-$TIMESTAMP.tar.gz" /data/coolify

# Upload to Google Drive
echo "Uploading backups to Google Drive..."
rclone copy --immutable "$BACKUP_DIR" "$GDRIVE_REMOTE"

# Clean up
rm -rf "$BACKUP_DIR"

echo "Backup complete."
