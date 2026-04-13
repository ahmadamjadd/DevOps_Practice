#!/usr/bin/bash

REG_NO="${1:-2023361}"
ARCHIVE_NAME="${REG_NO}.tar.gz"

FILES=$(find . -maxdepth 1 -type f -name "*.sh")

if [ -z "$FILES" ]; then
    echo "No .sh files found."
    exit 1
fi

tar -czf "$ARCHIVE_NAME" $FILES
echo "Created archive: $ARCHIVE_NAME"


