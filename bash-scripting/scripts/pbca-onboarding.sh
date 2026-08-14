#!/bin/bash
if [ $# -eq 0 ]; then 
       echo "Please enter filename"
       echo "usage: sudo ./pbca-onboarding.sh filename.txt"
       exit 1   
fi     
FILENAME=$1
if [ ! -f $FILENAME ]; then 
	echo "file not found"
	exit 1
fi
if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root user"
	exit 1
fi
	while IFS= read -r STAFF; do
		if  id "$STAFF" &>/dev/null ; then
		       echo "Staff: $STAFF already exist"
	       else
	echo "Creating user $STAFF ...."	       
		sudo useradd -m -s /bin/bash $STAFF
	      if [ $? -eq 0 ];then	
		echo "Staff: $STAFF has been created successfully"
	else
		echo "Staff: $STAFF creation failed"
		exit 1
		fi
	fi 
	done < $FILENAME




