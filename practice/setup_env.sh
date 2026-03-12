#!/bin/bash

# 1. Create the user 'deployer' if they don't exist
if id "deployer" &>/dev/null; then
    echo "User deployer already exists."
else
    sudo useradd -m -s /bin/bash deployer
    echo "deployer:12345678" | sudo chpasswd
    sudo usermod -aG sudo deployer
fi

# 2. Create directory for keys and generate RSA pair (Non-interactive)
mkdir -p /home/muhammad_ahmad/.ssh/keys
if [ ! -f /home/muhammad_ahmad/.ssh/keys/deployer ]; then
    ssh-keygen -t rsa -b 2048 -N "" -f /home/muhammad_ahmad/.ssh/keys/deployer
fi

# 3. Set strict permissions for the private key (Required by SSH)
chmod 700 /home/muhammad_ahmad/.ssh/keys
chmod 600 /home/muhammad_ahmad/.ssh/keys/deployer
chmod 644 /home/muhammad_ahmad/.ssh/keys/deployer.pub

# 4. Set up the deployer's .ssh directory and authorized_keys
sudo mkdir -p /home/deployer/.ssh
sudo chmod 700 /home/deployer/.ssh
cat /home/muhammad_ahmad/.ssh/keys/deployer.pub | sudo tee /home/deployer/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/deployer/.ssh/authorized_keys
sudo chown -R deployer:deployer /home/deployer/.ssh

# 5. Disable Password Authentication for better security
if grep -q "PasswordAuthentication" /etc/ssh/sshd_config; then
    sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
else
    echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart SSH to apply changes
sudo systemctl restart ssh

# 6. Configure SSH Config for easy login (using a Here-Doc)
# Use '>>' to append, but check if it's already there to avoid duplicates
if ! grep -q "Host deployer" /home/muhammad_ahmad/.ssh/config 2>/dev/null; then
    cat <<- 'EOF' >> /home/muhammad_ahmad/.ssh/config
Host deployer
    HostName 127.0.0.1
    User deployer
    IdentityFile /home/muhammad_ahmad/.ssh/keys/deployer
EOF
fi

echo "Part 1 Complete: You can now run 'ssh deployer' from your terminal."



sudo mkdir -p /opt/logs
sudo chmod 777 /opt/logs
docker network create webnet > /dev/null
docker run -d --name backend --network webnet ubuntu/apache2 > /dev/null
docker run -d --name proxy --network webnet -p 8080:80 -v /opt/logs:/var/log/nginx nginx > /dev/null

docker exec proxy bash -c "cat << 'EOF' > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
    }
}
EOF"

# 2. Reload Nginx using the native command
docker exec proxy nginx -s reload

cat << 'EOF' > /opt/logs/access.log
192.168.1.10 - - [12/Mar/2026:10:00:01 +0000] "GET /index.html HTTP/1.1" 200 1043
192.168.1.11 - - [12/Mar/2026:10:00:05 +0000] "GET /styles.css HTTP/1.1" 200 532
10.0.0.50 - - [12/Mar/2026:10:01:10 +0000] "POST /login HTTP/1.1" 500 245
192.168.1.10 - - [12/Mar/2026:10:02:15 +0000] "GET /api/data HTTP/1.1" 500 120
172.16.0.5 - - [12/Mar/2026:10:03:20 +0000] "GET /favicon.ico HTTP/1.1" 404 15
EOF


cut -d " " -f1,9 /opt/logs/access.log
awk '$9 == "500" {count ++} END {printf("count: %d", count)}' /opt/logs/access.log

    

