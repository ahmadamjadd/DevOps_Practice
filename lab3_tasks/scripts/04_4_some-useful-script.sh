#! /bin/bash

# Installing atop monitoring service on different distributions
os_release=/etc/os-release

if grep -q "Ubuntu" $os_release; then
	sudo apt install atop -y
fi 

if grep -q "Fedora" $os_release || grep -q "Centos" $os_release; then
	sudo yum install atop
fi



