#! /usr/bin/bash

DEST="/home/devopsuser/backup"

mkdir -p "$DEST"

while true; do
    filename="$DEST/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz"
    sudo tar -czf "$filename" /devopsdir
    echo "Backup created: $filename"

    sleep 600
done
