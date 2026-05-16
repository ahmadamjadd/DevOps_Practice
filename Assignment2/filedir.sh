#!/bin/bash

sudo mkdir -p /devopsdir

echo "AoA, Hello DevOps!" | sudo tee /devopsdir/devopsfile.txt > /dev/null

sudo chmod 755 /devopsdir
sudo chmod 644 /devopsdir/devopsfile.txt

sudo setfacl -m u:devopsuser:rwx /devopsdir
sudo setfacl -m u:devopsuser:rw /devopsdir/devopsfile.txt
