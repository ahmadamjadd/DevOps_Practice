#!/bin/bash

# Create sample files with different timestamps and sizes
touch -d "1 day ago" file1.txt
touch -d "1 day ago" file2.txt
touch -d "1 day ago" file3.txt

touch -d "10 days ago" file4.txt
touch -d "10 days ago" file5.txt
touch -d "10 days ago" file6.txt
touch -d "10 days ago" file7.txt

touch -d "3 months ago" file8.txt
touch -d "3 months ago" file9.txt
touch -d "3 months ago" file10.txt

touch -d "2 months ago" file11.txt
touch -d "2 months ago" file12.txt
touch -d "2 months ago" file13.txt

touch -d "4 months ago" file14.txt
touch -d "4 months ago" file15.txt

touch -d "1 month ago" file16.txt
touch -d "1 month ago" file17.txt

touch -d "5 months ago" file18.txt
touch -d "5 months ago" file19.txt
touch -d "5 months ago" file20.txt
touch -d "5 months ago" file21.txt
touch -d "5 months ago" file22.txt
touch -d "5 months ago" file23.txt

touch -d "6 months ago" file24.txt
touch -d "6 months ago" file25.txt
touch -d "6 months ago" file26.txt

# Create files with different sizes (in bytes)
dd if=/dev/zero of=small_file1.txt bs=1024 count=10
touch -d "1 month ago" small_file1.txt

dd if=/dev/zero of=medium_file1.txt bs=1024 count=100
touch -d "2 months ago" medium_file1.txt

dd if=/dev/zero of=large_file1.txt bs=1024 count=1000
touch -d "3 months ago" large_file1.txt

dd if=/dev/zero of=small_file2.txt bs=1024 count=50
touch -d "4 months ago" small_file2.txt

dd if=/dev/zero of=medium_file2.txt bs=1024 count=200
touch -d "5 months ago" medium_file2.txt

dd if=/dev/zero of=large_file2.txt bs=1024 count=500
touch -d "6 months ago" large_file2.txt

dd if=/dev/zero of=small_file3.txt bs=1024 count=5
touch -d "1 day ago" small_file3.txt

dd if=/dev/zero of=medium_file3.txt bs=1024 count=50
touch -d "10 days ago" medium_file3.txt

dd if=/dev/zero of=large_file3.txt bs=1024 count=200
touch -d "3 months ago" large_file3.txt
