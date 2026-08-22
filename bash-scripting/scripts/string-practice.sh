#! /bin/bash 
EMAIL="mrs.johnson@pbca.edu"
USERNAME=${EMAIL%%@*}
echo "Username: ${EMAIL%%@*}"
echo "Domain: ${EMAIL##*@}"
DOMAIN=${EMAIL##*@}
echo "Organization: ${DOMAIN%.*}"
echo "Extension: ${EMAIL##*.}"
id $USERNAME &>/dev/null
if [ $? -eq 0 ]; then
	echo "$USERNAME already exist"
       exit 0	
else 
	echo "Creating $USERNAME account..."
	sudo useradd -m -s /bin/bash $USERNAME
	if [ $? -eq 0 ]; then
		echo "Account: $USERNAME created successfull"
	else
 echo "Account: $USERNAME creation failed"
 exit 1
	fi 
fi 

