#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "WARNING: This will delete all files from samba share and users home directory"

read -p "Please enter username to delete: " USER_NAME

if [ -z $USER_NAME ]
then
        echo "No user name entered"
	exit
fi

id -u $USER_NAME > /dev/null 2>&1 || { echo "User $USER_NAME does not exist"; exit 1; }
read -r -p "Are you sure you want to delete $USER_NAME? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo userdel -r $USER_NAME && sudo rm -rf /samba/anonymous/$USER_NAME

else
    do_something_else
fi
