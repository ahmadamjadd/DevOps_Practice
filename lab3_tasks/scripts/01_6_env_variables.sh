#!/usr/bin/bash

MYVAR="Hello"
export MYEXPORTED="World"

echo "Main shell:"
echo $MYVAR
echo $MYEXPORTED


# A normal variable lives only in the current shell.
echo "Subshell:"
bash -c 'echo $MYVAR; echo $MYEXPORTED'

echo -e "\n=================="
echo -e "Task to do:"
echo -e "=================="
echo -e "Can you create and export an enviroment variable of your choice in your terminal and ";
echo "  print it in your bash script file?"
echo -e "\n Next close your terminal and open again and execute the script containing your create variable"
echo "  What did you observed?"
