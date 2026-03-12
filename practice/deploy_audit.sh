#!/bin/bash

# 1. Prep
sudo mkdir -p /tmp/network_logs
docker rm -f web_server auditor 2>/dev/null
docker network rm secure_app_net 2>/dev/null || true

# 2. Setup
docker network create secure_app_net

# Start Nginx
docker run -d --name web_server --network secure_app_net -p 8086:80 nginx

# Start Ubuntu (using sleep to keep the container alive)
docker run -dit --name auditor --network secure_app_net ubuntu 

# 3. Install wget inside the running Ubuntu container
# We use -qq to keep the output clean for the "exam"
docker exec auditor apt-get update 
docker exec auditor apt-get install -y wget

# 4. Execute the check
docker exec auditor wget -q --spider http://web_server

if [ $? -eq 0 ]; then
    echo "Audit Success: $(date)" | sudo tee -a /tmp/network_logs/audit.log
    echo "Log updated successfully."
else
    echo "Network error: Target unreachable"
fi


