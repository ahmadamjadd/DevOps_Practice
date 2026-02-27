#! /usr/bin/bash

for file in $(ls ./*.sh); do
    echo -e "$file \n" >> lab_reference.sh
    cat $file >> lab_reference.sh
    echo -e "\n\n\n\n\n" >> lab_reference.sh
done 

