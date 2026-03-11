#! /usr/bin/bash

file=/etc/passwd
output=$(grep sajidali $file)

if [ $? -eq 0 ]; then
  echo $output
else
  echo "couldn't found user details"
fi

echo "scripts ends here"
