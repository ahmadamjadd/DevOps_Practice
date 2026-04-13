#!/usr/bin/bash

# Q8: Find all assignment shell scripts and bundle them into one archive.

# Collect all .sh files from current directory.
FILES=$(find . -maxdepth 1 -type f -name "*.sh")

# Stop if no scripts are found.
if [ -z "$FILES" ]; then
    echo "No .sh files found."
    exit 1
fi

# Create the required submission tar.gz.
tar -czf 2023361.tar.gz $FILES

# Creating assignment bundle in zip format mentioned in submission guidelines.
zip -q assignment2_2023361.zip $FILES


