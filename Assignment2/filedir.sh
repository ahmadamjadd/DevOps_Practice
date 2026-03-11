#!/bin/bash

# 1. Create the directory
sudo mkdir -p /devopsdir

# 2. Create the file and write the text
echo "AoA, Hello DevOps!" | sudo tee /devopsdir/devopsfile.txt > /devopsdir/devopsfile.txt

# 3. Set standard permissions (Others get Read)
sudo chmod 755 /devopsdir
sudo chmod 644 /devopsdir/devopsfile.txt

# 4. Set specific ACLs for devopsuser
sudo setfacl -m u:devopsuser:rwx /devopsdir
sudo setfacl -m u:devopsuser:rw /devopsdir/devopsfile.txt
