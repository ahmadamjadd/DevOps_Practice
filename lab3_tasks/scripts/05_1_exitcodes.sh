#! /usr/bin/bash

if [ ! -d /sajid ]; then
  echo "in if condition"
  sudo mkdir /sajid
  ls /sajid
else
  echo "else"
fi
echo $?
