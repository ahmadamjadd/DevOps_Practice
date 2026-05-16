#!/bin/bash

# Automatic Prefixing based on current directory 
curr_dir=$(pwd | awk -F'/' '{print $NF}')

# Handle judgehosts argument: extract N from --judgehosts=N 
num_judges=$(echo "$2" | cut -d'=' -f2)
if [[ -z "$num_judges" || ! "$num_judges" =~ ^[0-9]+$ ]]; then
    num_judges=1
fi

if [ "$1" == "-sp" ]; then
    echo "Stopping services for ${curr_dir}..." 
    docker stop "${curr_dir}_db" "${curr_dir}_server" 2>/dev/null
    docker stop $(docker ps -a -q --filter name="${curr_dir}_judge") 2>/dev/null

elif [ "$1" == "-st" ]; then
    echo "Starting services for ${curr_dir}..." 
    docker start "${curr_dir}_db" "${curr_dir}_server" 2>/dev/null
    echo "Starting judgehosts..."
    sleep 20
    docker start $(docker ps -a -q --filter name="${curr_dir}_judge") 2>/dev/null

elif [ "$1" == "-dt" ]; then
    echo "Deleting services (preserving volumes) for ${curr_dir}..." [cite: 40, 44]
    docker rm -f "${curr_dir}_db" "${curr_dir}_server" 2>/dev/null
    docker rm -f $(docker ps -a -q --filter name="${curr_dir}_judge") 2>/dev/null
    docker network rm "${curr_dir}_domjudge_net" 2>/dev/null

elif [ "$1" == "-i" ] || [ -z "$1" ]; then
    echo "Deploying DOMjudge for ${curr_dir}..." 

    # Cleanup existing containers before re-deploy [cite: 39]
    docker rm -f "${curr_dir}_db" "${curr_dir}_server" 2>/dev/null
    docker rm -f $(docker ps -a -q --filter name="${curr_dir}_judge") 2>/dev/null

    # Create network and volume [cite: 42, 44]
    docker network create "${curr_dir}_domjudge_net" 2>/dev/null
    docker volume create "${curr_dir}_db_data" 2>/dev/null

    # Start Database [cite: 14]
    docker run -dit \
        --name "${curr_dir}_db" \
        --network "${curr_dir}_domjudge_net" \
        -e MYSQL_ROOT_PASSWORD=rootpw \
        -e MYSQL_USER=domjudge \
        -e MYSQL_PASSWORD=djpw \
        -e MYSQL_DATABASE=domjudge \
        -v "${curr_dir}_db_data":/var/lib/mysql \
        mariadb --max-allowed-packet=64M

    echo "Waiting for Database (20s)..."
    sleep 20

    # Start DOMserver [cite: 14, 16]
    docker run -dit \
        --name "${curr_dir}_server" \
        --network "${curr_dir}_domjudge_net" \
        --network-alias domserver \
        -e MYSQL_HOST="${curr_dir}_db" \
        -e MYSQL_ROOT_PASSWORD=rootpw \
        -e MYSQL_USER=domjudge \
        -e MYSQL_PASSWORD=djpw \
        -e MYSQL_DATABASE=domjudge \
        -p 80:80 \
        domjudge/domserver

    echo "Waiting for Server to initialize (90s)..."
    sleep 90

    # Synchronize credentials using modern syntax
    echo "Synchronizing credentials..."
    docker exec "${curr_dir}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password admin admin123
    docker exec "${curr_dir}_server" /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password judgehost password

    # Start Judgehosts [cite: 15, 16, 41]
    for i in $(seq 1 $num_judges); do
        docker run -dit \
            --name "${curr_dir}_judge${i}" \
            --privileged \
            --network "${curr_dir}_domjudge_net" \
            --cgroupns=host \
            -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
            -e DOMSERVER_BASEURL="http://domserver/" \
            -e JUDGEDAEMON_PASSWORD=password \
            domjudge/judgehost
    done

    echo "===================================================="
    echo "            DEPLOYMENT SUMMARY"
    echo "===================================================="
    docker ps --filter name="${curr_dir}"
    echo "----------------------------------------------------"
    docker network ls --filter name="${curr_dir}"
    docker volume ls --filter name="${curr_dir}"
    echo "Manual Steps: Login at http://localhost with admin/admin123"
    echo "===================================================="

else
    echo "Usage: $0 {-i|-sp|-st|-dt} [--judgehosts=num]"
fi