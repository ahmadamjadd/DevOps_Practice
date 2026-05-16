#! /usr/bin/bash

sudo useradd -m -s /bin/bash devopsuser
echo "devopsuser:12345678" | sudo chpasswd

sudo groupadd devopsgroup
sudo usermod -aG devopsgroup devopsuser
