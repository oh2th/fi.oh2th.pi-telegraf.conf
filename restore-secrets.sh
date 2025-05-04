#!/bin/bash

# Input file (from backup)
BACKUP_FILE="telegraf_secrets_raw_backup.txt"

# Check for sudo
if [[ "$(id -u)" -ne 0 ]]; then
  echo "This script should be run with sudo."
  exit 1
fi

# Read and restore each secret
grep -E '^[^#].+=.+$' "$BACKUP_FILE" | while read -r line; do
  # Extract store, key, and value
  store_and_key=$(echo "$line" | cut -d= -f1 | xargs)
  value=$(echo "$line" | cut -d= -f2- | xargs)

  store=$(echo "$store_and_key" | cut -d: -f1)
  key=$(echo "$store_and_key" | cut -d: -f2)

  echo "Restoring: $key to store: $store"
  echo "$value" | sudo -u telegraf telegraf secrets set "$store" "$key"
done

echo "✅ Restore complete."
