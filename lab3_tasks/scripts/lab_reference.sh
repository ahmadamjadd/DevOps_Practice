./01_1_first_script.sh 

#! /usr/bin/bash
# #! is a shebang, tells shell which interpeter to use
# is a utility/program to be used


echo "Hello dear students!" 






./01_2_first_script_bin.sh 

#! /usr/bin/cat
# #! is a shebang, tells shell which interpeter to use
# is a utility/program to be used


echo "Hello dear students!" 






./01_3_variables.sh 

#!/usr/bin/bash

# Normal variables
COURSE="DevOps"
TOPIC="Scripting"

echo "I am studying $TOPIC in $COURSE"

# Normal variables storing output of the linux command
HOSTNAME=$(uname -n)
CURRENT_USER=$(whoami)
CURRENT_DATE=$(date)

echo -e "\nSystem Information:"
echo -e "\t HostName: $HOSTNAME"
echo -e "\t Current User: $CURRENT_USER"
echo -e "\t Current Date: $CURRENT_DATE"






./01_4_variables_exercise.sh 

#!/usr/bin/bash

echo -e "\nYour Task:"
echo -e "\t Create a Bash script that defines two normal variables of your choice and prints their values."
echo -e "\t In the same script, store the following system information in separate variables and print them:"
echo -e "\t\t Kernel name"
echo -e "\t\t Linux version"
echo -e "\t\t Operating system"






./01_5_env_variables.sh 

#!/usr/bin/bash

# Environment variables created by system
# They exists before your script runs

echo "Home Directory: $HOME"
echo "Logged in User: $USER"
echo "Current Shell: $SHELL"
echo "Path Variable: $PATH"

# They are exported so child processes can access them
# So, they have bigger scope then normal variables






./01_6_env_variables.sh 

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






./01_7_env_variables.sh 

#!/usr/bin/bash
source .env

echo "Main shell:"
echo $DB_HOST
echo $DB_USER
echo $DB_PASS
echo $APP_ENV


# A normal variable lives only in the current shell.
echo -e "\nSubshell:"
bash -c 'echo $DB_HOST; echo $DB_USER; echo $DB_PASS; echo $APP_ENV'

echo -e "\n=================="
echo -e "Task to do:"
echo -e "=================="
echo -e " Create a file named db_secrets.env containing a database username and password.";
echo "  Set the file permissions so only your user can read it."
echo "  Then write a Bash script that safely loads these variables and prints them."
echo "  Test that the script can access the variables, and that other users cannot read the secret file."






./02_1_heredoc_createsamplefile.sh 

#! /usr/bin/bash
cat <<- 'EOF' > ec2info.html
	<html>
    		<head>
        		<title>
        			AWS EC2 Information
        		</title>
    		</head>

    		<body>
    			<h1>AWS EC2 Information</h1>
    		</body>
	</html>
EOF






./02_2_heredoc_createsamplefile.sh 

#! /usr/bin/bash
(
cat <<- 'EOF'
	<html>
    		<head>
        		<title>
        			AWS EC2 Information
        		</title>
    		</head>

    		<body>
    			<h1>AWS EC2 Information</h1>
    		</body>
	</html>
EOF
) > ec2info.html






./02_3_heredoc_createsamplefile2.sh 

#! /usr/bin/bash
(
cat <<- 'EOF'

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPres

EOF
) > .htaccess_sample






./02_4_heredoc_mlc_variables.sh 

#! /usr/bin/bash

#Also known as constant variables
#In Unix, constant variables are defined in UPPERCASE
TODAY=$(date +%F)

<<- COMMENT
AoA, today is ${TODAY} 
You can use Heredoc to add multiline comments
Here is the second line comment	
COMMENT

cat << EOF
AoA, today is ${TODAY}
This date is coming from a variable named TODAY in a script
This script also contains multiline comments, use cat < heredoc_mlc_varaibles.sh to take a look.
EOF







./02_5_heredoc_runcommands_on_remote_server.sh 

#! /usr/bin/bash

uname='pc-38'

ssh -T ${uname}@127.0.0.1 << COMMANDS

mkdir test
cd test
touch test.txt
echo 'hello man' > test.txt

COMMANDS






./03_user_input.sh 

#! /usr/bin/bash

#<< COMMENT
echo "please enter your name"
read yname

echo "please enter your reg#"
read regnumber


cat <<- BLOCK
	Hello dear ${yname},
	Thank you for joining DevOps course
	Your registration number is: ${regnumber}
BLOCK
#COMMENT


<< BLOCK

read -p 'please enter your name' yname
read -p 'please enter your reg#' regnumber

cat <<- INNERBLOCK
        Hello dear ${yname},
        Thank you for joining DevOps course
        Your registration number is: ${regnumber}
INNERBLOCK

BLOCK







./04_2_flow_control_with_exit_codes.sh 

#! /usr/bin/bash

file=/etc/passwd
output=$(grep sajidali $file)

if [ $? -eq 0 ]; then
  echo $output
else
  echo "couldn't found user details"
fi

echo "scripts ends here"






./04_3_flow_control_with_commands.sh 

#! /usr/bin/bash

# Use of normal commands

package=apache2

if which $package ; then
  echo "$package already exists"
else
  echo "$package does not exists"
  echo "Installing package $package"
  sudo apt install -y $package >> apache_installation_log.log
  if [ $? -eq 0 ]; then
    echo "$package successfully installed"
    echo "You can find $package here:$(which $package)"
  else
    echo "$package did not install. please see the log file"
  fi
fi






./04_4_some-useful-script.sh 

#! /bin/bash

# Installing atop monitoring service on different distributions
os_release=/etc/os-release

if grep -q "Ubuntu" $os_release; then
	sudo apt install atop -y
fi 

if grep -q "Fedora" $os_release || grep -q "Centos" $os_release; then
	sudo yum install atop
fi









./04_5_case_control.sh 

#! /usr/bin/bash

#<< COMMENT
echo "please type the operation you want to perform, ADD, SUB or  DIV"
read operation

echo "please enter first number"
read number1

echo "please enter second number"
read number2

case $operation in
	'ADD' )
		echo "$number1 + $number2 : "$((number1 + number2))
		;;
	'SUB' ) 
		echo "$number1 - $number2 : "$((number1 - number2))
		;;
	'DIV' ) 
		echo "$number1 / $number2 : "$((number1 / number2))
		;;
	* ) 
		echo "Please type valid operation"	
		exit 1
esac
exit 0
#COMMENT






./05_1_exitcodes.sh 

#! /usr/bin/bash

if [ ! -d /sajid ]; then
  echo "in if condition"
  sudo mkdir /sajid
  ls /sajid
else
  echo "else"
fi
echo $?






./05_2_exitcodes_manipulating_with_your_own_exitcodes.sh 

#! /usr/bin/bash

# Use of Exit Codes

# special variable $? --> env variable holds the exit code for the last executed command
# Manipulating with exit codes

read -p "Enter the number please: " number

if [ $number -gt 10 ]; then
  echo "Your entered the right number"
  exit 0
else
  echo "You entered number less than 10"
  exit 1
fi








./05_3_exitcodes_manipulating_with_your_own_exitcodes_1.sh 

#! /usr/bin/bash

command=./exitcodes_manipulating_with_your_own_exitcodes.sh

command $command

if [ $? -eq 0 ] ; then
  echo "$command executed successfully"
else
  echo "$command failed and exit code for this is: $?"
fi






./06_1_while_loop.sh 

#! /usr/bin/bash

echo "Hi, this program will print the table of the number you like"
echo "Let's start"

echo "Please enter the number between 1 - 9"
read number

nextdigit=1

while [ "$nextdigit" -lt 11 ]; do
	echo "$number x $nextdigit = "$(( number * nextdigit  ))
	nextdigit=$((nextdigit + 1))
done







./06_2_while_loop.sh 

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







./06_3_while_loop_reading_from_file.sh 

#! /usr/bin/bash

while read -r line
do
  echo $line
  sleep 0.3
done < testfile













./07_1_user_argument.sh 

#! /usr/bin/bash

#<< COMMENT
echo "please enter first number"
read number1

echo "please enter second number"
read number2

if [ "$1" == "ADD" ]; then
	echo "Your sum is: "$((number1 + number2))
elif [ "$1" == "SUB" ]; then
	echo "Your subtraction is: "$((number1 - number2))
elif [ "$1" == "DIV" ]; then
	echo "Divison of two numbers is: "$((number1 / number2))
else
	echo 'please provide valid argument'
	exit 1
fi
exit 0
#COMMENT






./10_until_loop.sh 

#! /usr/bin/bash

echo "Hi, this program will print the table of the number you like"
echo "Let's start"

echo "Please enter the number between 1 - 9"
read number

nextdigit=1

until [ "$nextdigit" -gt 10 ]; do
	echo "$number x $nextdigit = "$(( number * nextdigit  ))
	nextdigit=$((nextdigit + 1))
done







./11_until_loop_for_menu.sh 

#!/bin/bash

selection=
until [ "$selection" = "0" ]; do
    echo "
    PROGRAM MENU
    1 - Display free disk space
    2 - Display free memory

    0 - exit program
"
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
        1 ) df ;;
        2 ) free ;;
        0 ) exit ;;
        * ) echo "Please enter 1, 2, or 0"
    esac
done






./12_1_for_loop.sh 

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








./12_2_for_loop.sh 

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






./12_for_loop.sh 

#! /usr/bin/bash

for i in word1 word2 word3; do
    echo "$i"
done

for FILE in *; do
	echo $FILE

	if [ -d "$FILE"  ]; then
		echo "It is file"
	fi
done







./13_for_loop_gen_sshkeys.sh 

#! /usr/bin/bash

basepath='./keys'

create_user_and_keys(){
	useradd -m $1 -p $1
	ssh-keygen -f $basepath/$1 -N " "$1
}

for user in u2019123 u2019124 u2019523; do
	create_user_and_keys $user
done







./exercise1.sh 

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






./exercise2.sh 

#! /usr/bin/bash


export my_variable="CHAAAAAAAAAAAAAAAAAAAAAAA"

echo "Printing that variable: $my_variable"






./exercise3.sh 

#! /usr/bin/bash

source ./db_secrets.env

echo -e "$name"
echo -e "$pass"






./task4.sh 

#! /usr/bin/bash

for file in $(ls ./*.sh); do
    echo -e "$file \n" >> lab_reference.sh
    cat $file >> lab_reference.sh
    echo -e "\n\n\n\n\n" >> lab_reference.sh
done 







