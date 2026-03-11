#! /usr/bin/bash

command=./exitcodes_manipulating_with_your_own_exitcodes.sh

command $command

if [ $? -eq 0 ] ; then
  echo "$command executed successfully"
else
  echo "$command failed and exit code for this is: $?"
fi
