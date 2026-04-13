#! /usr/bin/bash

# Q5: Create a backup of /devopsdir every 10 minutes in /home/devopsuser/backup.

DEST="/home/devopsuser/backup"

# Ensure destination directory exists.
mkdir -p "$DEST"

# Infinite loop to take recurring backups without cron.
while true; do
    # Use timestamp in filename so each backup remains unique.
    filename="$DEST/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz"
    sudo tar -czf "$filename" /devopsdir
    echo "Backup created: $filename"

    # Wait 10 minutes before next backup.
    sleep 600
done
