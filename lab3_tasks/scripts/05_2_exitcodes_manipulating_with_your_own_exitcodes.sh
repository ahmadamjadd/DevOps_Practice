#! /usr/bin/bash

# Use of Exit Codes

# special variable $? --> env variable holds the exit code for the last executed command
# Manipulating with exit codes

read -p "Enter the number please: " number

if [ $number -gt 10 ]; then
  echo "Your entered the right number"
  exit 0
else
  echo "You entered number less than 10"
  exit 1
fi


