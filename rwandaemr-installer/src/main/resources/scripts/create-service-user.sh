#!/bin/bash

## load variables from the vars.txt file
source vars.txt

home_dir=${parent_dir}

if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
  echo "Checking if user doesn't exist"
  if [ $(id -u) -eq 0 ]; then
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists! Skipping!"
		exit 1
	else
		useradd -m ${username} -d /opt/${home_dir} -s /bin/bash
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
	fi
else
	echo "We are currently not creating users for environments other than demo, prod and test"
	exit 2
fi
