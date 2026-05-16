#!/bin/bash

DEST="/home/devopsuser/backup"

mkdir -p "$DEST"

tar -czf "$DEST/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz" /devopsdir

JOB="*/10 * * * * $(realpath $0)"
(crontab -l 2>/dev/null | grep -Fq "$(realpath $0)") || (crontab -l 2>/dev/null; echo "$JOB") | crontab -