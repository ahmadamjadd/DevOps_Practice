#!/bin/bash

# Q5 bonus: create one backup now and auto-register cron job for every 10 minutes.
DEST="/home/devopsuser/backup"

# Ensure backup directory exists in devopsuser home.
mkdir -p "$DEST"

# Create a timestamped tar.gz backup of /devopsdir.
tar -czf "$DEST/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz" /devopsdir

# Install cron entry only if it does not already exist.
JOB="*/10 * * * * $(realpath $0)"
(crontab -l 2>/dev/null | grep -Fq "$(realpath $0)") || (crontab -l 2>/dev/null; echo "$JOB") | crontab -