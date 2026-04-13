#! /usr/bin/bash

# Q2: Create user/group and add user to the target group.

# Create the required user with home directory and bash shell.
sudo useradd -m -s /bin/bash devopsuser
# Set a simple password using chpasswd.
echo "devopsuser:12345678" | sudo chpasswd

# Create required group and add user to it.
sudo groupadd devopsgroup
sudo usermod -aG devopsgroup devopsuser
