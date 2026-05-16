#!/usr/bin/bash

FILES=$(find . -maxdepth 1 -type f -name "*.sh")

if [ -z "$FILES" ]; then
    echo "No .sh files found."
    exit 1
fi

tar -czf 2023361.tar.gz $FILES

zip -q assignment2_2023361.zip $FILES


