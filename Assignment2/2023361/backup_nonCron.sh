#! /usr/bin/bash

DEST="/home/devopsuser/backup"
mkdir -p $DEST
while true; do
    FileName="$DEST/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz" 
    sudo tar -cvzf $FileName /devopsdir
    echo "File Created"
    sleep 600
done

