#!/bin/bash

username=$(echo "$1" | tr -d '[:punct:]')
homeDir="$1"

if [ $(id -u) -eq 0 ]; then
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists! Skipping!"
		exit 1
	else
		useradd -m ${username} -d $(pwd)/${homeDir} -s /bin/bash
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi
