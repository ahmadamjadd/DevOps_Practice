#! /usr/bin/bash

# use of for loop
# Mostly used where need to do similar actions on set of items


<<- FIRST
for i in word1 word2 word3; do
	echo $i
	sleep 0.2
done

FIRST

<<- SECOND

# iterating over set items in for
for number in 1 2 3 4 5; do
	echo $number
	sleep 0.2
done

SECOND

# ranges in for loop
<<- THIRD
for number in {1..10}
do
	echo $number
	sleep 0.3
done
THIRD

# conventional use similar to other programming langauges
<<- FOURTH
for ((counter=1 ; counter<=5; counter++ )); do
	echo "Hahaha"
	sleep 0.3
	continue
done
FOURTH

#iterating over arrays

<<- FIFTH
array=(1 2 3)

for item in ${array[@]}
do
    echo "$item"
    sleep 0.3
done
FIFTH


