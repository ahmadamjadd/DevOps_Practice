#!/bin/bash

# Q4: Create /devopsdir and apply required permissions.

# Create the target directory.
sudo mkdir -p /devopsdir

# Create devopsfile.txt and write required message.
echo "AoA, Hello DevOps!" | sudo tee /devopsdir/devopsfile.txt > /dev/null

# Standard permissions: others can read directory and file.
sudo chmod 755 /devopsdir
sudo chmod 644 /devopsdir/devopsfile.txt

# ACLs: devopsuser gets rwx on directory and rw on file.
sudo setfacl -m u:devopsuser:rwx /devopsdir
sudo setfacl -m u:devopsuser:rw /devopsdir/devopsfile.txt
