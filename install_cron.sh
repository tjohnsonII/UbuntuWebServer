#!/bin/bash

# Variables
CRON_JOB="*/30 * * * * /usr/bin/python3 /home/tim2/UbuntuWebServer/deep_scan.py"
CRONTAB_BACKUP="/tmp/current_crontab.bak"

echo "[*] Backing up current crontab to $CRONTAB_BACKUP..."
crontab -l > "$CRONTAB_BACKUP" 2>/dev/null

if grep -Fxq "$CRON_JOB" "$CRONTAB_BACKUP"; then
    echo "[✓] Cron job already exists. Nothing to do."
else
    echo "[*] Adding deep scan cron job..."
    echo "$CRON_JOB" >> "$CRONTAB_BACKUP"
    crontab "$CRONTAB_BACKUP"
    echo "[✓] Cron job installed to run every 30 minutes."
fi

# Clean up
rm "$CRONTAB_BACKUP"
