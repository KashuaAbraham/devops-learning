#!/bin/bash
# PBCA Emergency staff account creation
if [ $# -eq 0  ]; then 
	echo "No name input"
	echo "Usage: sudo ./pbca-users.sh username1 username2 username3"
	exit 1 
fi
if [ $EUID -ne 0 ]; then 
	echo "ERROR: Please run as root with sudo"
	exit 1 
fi
for STAFF in $@; do 
	echo "Processing staff: $STAFF"
	id $STAFF > /dev/null 2>&1 
	if [ $? -eq 0 ]; then 
		echo "User: $STAFF already exist"
	else 
		sudo useradd -m -s /bin/bash $STAFF
		if [ $? -eq 0 ]; then 
			echo "User $STAFF added successfully"
		else
			echo "User $STAFF not successful"
			exit 1 
		fi
	fi
done
echo "All Staff processed"
