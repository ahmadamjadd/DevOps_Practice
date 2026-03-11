#! /usr/bin/bash

# Iterating over directories content using for loop

#<<- FIRST
for file in *; do
	echo $file

	if [ -d $file  ]; then
		echo "----- It is directory"
	fi
	sleep 0.3
done
#FIRST

#reading file contets using for 
<<- SECOND
for line in $(cat testfile)
do
	echo $line
	sleep 0.3
done
SECOND
