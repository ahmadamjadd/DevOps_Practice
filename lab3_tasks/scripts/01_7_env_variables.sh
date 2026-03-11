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
