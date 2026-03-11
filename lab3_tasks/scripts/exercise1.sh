#! /usr/bin/bash


name="Muhammad Ahmad Amjad"
attribute="Smart"

echo -e "\nHello everyone! $name is $attribute\n"

kernelName=$(uname -s)
operatingSystem=$(uname -o)
linuxVersion=$(uname -r)

echo -e "\t\tKernal name: $kernelName\n"
echo -e "\t\tLinux Version: $linuxVersion\n"
echo -e "\t\tOperating System: $operatingSystem\n"
