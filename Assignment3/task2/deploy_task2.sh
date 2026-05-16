#!/bin/bash

# Use current folder name as Compose project prefix.
curr_dir=$(pwd | awk -F'/' '{print $NF}')
export COMPOSE_PROJECT_NAME=$curr_dir

# Optional second argument format: --judgehosts=N (defaults to 1).
num_judges=$(echo "$2" | cut -d'=' -f2)
if [[ -z "$num_judges" || ! "$num_judges" =~ ^[0-9]+$ ]]; then
    num_judges=1
fi

if [ "$1" == "-sp" ]; then
    echo "Stopping Task 2 services for $COMPOSE_PROJECT_NAME..."
    docker compose stop

elif [ "$1" == "-st" ]; then
    echo "Starting Task 2 services for $COMPOSE_PROJECT_NAME..."
    docker compose start

elif [ "$1" == "-dt" ]; then
    echo "Deleting Task 2 services for $COMPOSE_PROJECT_NAME..."
    # Remove compose-managed containers and network; keep named volumes.
    docker compose down

elif [ "$1" == "-i" ] || [ -z "$1" ]; then
    echo "Deploying $num_judges judgehost(s) with prefix: $COMPOSE_PROJECT_NAME"
    
    # Start stack and scale judgehost service to requested count.
    docker compose up -d --scale judgehost=$num_judges
    
    echo "Synchronizing credentials..."
    
    # Set predictable credentials for assignment verification.
    docker exec -it ${COMPOSE_PROJECT_NAME}_server \
        /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password admin admin123
    
    docker exec -it ${COMPOSE_PROJECT_NAME}_server \
        /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password judgehost password
    
    echo "===================================================="
    echo "            TASK 2 DEPLOYMENT SUMMARY"
    echo "===================================================="
    echo "Admin Credentials: admin / admin123"
    echo "Judge Credentials: judgehost / password"
    echo "Prefix Used: $COMPOSE_PROJECT_NAME"
    echo "Manual Steps: Login at http://localhost with admin/admin123"
    echo "----------------------------------------------------"
    docker compose ps
    echo "===================================================="
else
    echo "Usage: $0 {-i|-sp|-st|-dt} [--judgehosts=num]"
fi