#! /usr/bin/bash

# Q1: Print basic kernel/system details and editor locations.

# Collect required system information.
kernel_name=$(uname -s)
kernel_relase=$(uname -r)
processor_type=$(uname -p)
operating_system=$(uname -o)

# Show kernel and OS summary.
echo -e "Kernel Name: $kernel_name \nKernel Release: $kernel_relase \nProcessor Type: $processor_type\nOperating System: $operating_system\n"

# Show favorite editor and its binary/man-page locations.
echo -e "\nFavourite Editor: VIM"
editor_location=$(whereis vim | awk '{print $2}')
editor_man_pages_location=$(whereis vim | awk '{print $5}')
echo -e "Location: $editor_location \nMan-Pages_Location: $editor_man_pages_location\n"
