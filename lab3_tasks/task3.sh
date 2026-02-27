#! /usr/bin/bash
touch nginx.log

if [ "$1" == "-i" ]; then
    sudo apt show nginx > nginx.log
   if [ $? -eq 0 ]; then
      echo "NGINX is already installed on your machine! You can see nginx.log file to see details"
      exit 0
   else
      sudo apt install nginx >> nginx.log
     if [ $? -eq 0 ]; then
        echo "Nginx installed successfully"
        exit 0
     else
        echo "Nginx installation failed!! See nginx.log file to see what happened"
        exit 1
     fi
   fi
elif [ "$1" == "-r" ]; then
   sudo apt show nginx > nginx.log
   if [ $? -eq 0 ]; then
       sudo apt remove nginx >> nginx.log
       if [ $? -eq 0 ]; then
          echo "Nginx removed successfully"
          exit 0
       else
          echo "Nginx removal failed!! See nginx.log file to see what happened"
          exit 1
       fi
   else
       echo "Nginx not installed!"
       exit 0
   fi
else
    echo "Incorrect flag! Type -i to install or -r to remove!"
    exit 1
fi
 
