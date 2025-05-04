#!/bin/bash

# Secret store ID
SECRET_STORE_ID="telegraf_secrets"
# Output file
BACKUP_FILE="telegraf_secrets.backup"

# Ensure we're running with sudo
if [[ "$(id -u)" -ne 0 ]]; then
  echo "This script should be run with sudo."
  exit 1
fi

# Write header
{
  echo "# Raw backup of Telegraf secrets"
  echo "# Store: $SECRET_STORE_ID"
  echo "# Created: $(date)"
  echo
} > "$BACKUP_FILE"

# List and backup each secret
sudo -u telegraf telegraf secrets list | tail -n +2 | while read -r key; do
  if [[ -z "$key" ]]; then continue; fi
  echo "Backing up: $key"
  sudo -u telegraf telegraf secrets get "$SECRET_STORE_ID" "$key" >> "$BACKUP_FILE"
done

chmod 600 "$BACKUP_FILE"
echo "✅ Backup complete: $BACKUP_FILE"
