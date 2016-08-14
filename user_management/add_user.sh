#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

read -p "Please enter user name: " USER_NAME

if [ -z $USER_NAME ]
then 
	echo "No user name entered"
	exit
fi

id -u $USER_NAME >/dev/null 2>&1 && { echo "User $USER_NAME already exists"; exit 1; }

echo "User name entered: $USER_NAME"


read -p "Make user admin? (No): " ADMIN_RIGHTS
ADMIN_RIGHTS=${ADMIN_RIGHTS:-No}
ADMIN_RIGHTS=${ADMIN_RIGHTS,,}

echo "Creating user $USER_NAME with Admin Rights: $ADMIN_RIGHTS"
sudo useradd $USER_NAME


echo "Please enter password for user"
sudo passwd $USER_NAME

if [ $ADMIN_RIGHTS == "yes" ]
then
	echo "Adding $USER_NAME to wheel (admin) group" 
	usermod -aG wheel $USER_NAME
fi

echo "Creating samba share for ${USER_NAME}"
sudo mkdir /samba/anonymous/${USER_NAME}
sudo chown -R ${USER_NAME}:${USER_NAME} /samba/anonymous/${USER_NAME}



