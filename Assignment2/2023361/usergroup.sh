#! /usr/bin/bash

sudo useradd -m -s /bin/bash devopsuser
# password passed will be as hashed to -p so setting password afterwards
echo "devopsuser:12345678" | sudo chpasswd
sudo groupadd devopsgroup
sudo usermod -aG devopsgroup devopsuser
