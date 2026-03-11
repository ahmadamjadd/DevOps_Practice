#!/usr/bin/bash

# Normal variables
COURSE="DevOps"
TOPIC="Scripting"

echo "I am studying $TOPIC in $COURSE"

# Normal variables storing output of the linux command
HOSTNAME=$(uname -n)
CURRENT_USER=$(whoami)
CURRENT_DATE=$(date)

echo -e "\nSystem Information:"
echo -e "\t HostName: $HOSTNAME"
echo -e "\t Current User: $CURRENT_USER"
echo -e "\t Current Date: $CURRENT_DATE"
