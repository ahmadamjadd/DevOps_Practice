#! /bin/bash

# use of simple while loop
# Its job is to do the same task over and over again until a condition is tru
# while [ expression ]; do statements done

read -p "Enter any number greater than 0: " number

while [ $number -ne 0 ]; do
  echo "$number"
  number=$(expr $number - 1)
  sleep 0.2
done

