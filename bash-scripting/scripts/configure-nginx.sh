#!/bin/bash
set -euo pipefail 
#Layer 1-CHECK NUMBER OF ARGUMENTS 

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <website_name> <web_root>"
    exit 1
fi

echo "Correct number of arguments supplied."
SITE_NAME="$1"
WEB_ROOT="$2"
#Check if argument is empty 
if [ -z "$SITE_NAME" ]; then 
	echo "Error: Website name cannot be empty."
	exit 1
fi
if [ -z "$WEB_ROOT" ]; then
	echo "Error: Web root cannot be empty."
	exit 1 
fi 
#check validity of website name
if [[ ! "$SITE_NAME" =~ ^[a-z0-9.-]+$ ]]; then
    echo "Error: Invalid website name."
    exit 1
fi
#check web root and make sure it has an absolute path
if [[ "$WEB_ROOT" != /* ]]; then
    echo "Error: Web root must be an absolute path."
    exit 1
fi
if [ "$WEB_ROOT" = "/" ]; then 
	echo "Error: Web root cannot be /"
	exit 1
fi
echo "Input validation successfull"
echo "Website name: $SITE_NAME"
echo "Web root: $WEB_ROOT"

#LAYER 2: Environment checks
if [ $EUID -ne 0 ]; then 
	echo "Error: You must run script as root user"
	exit 1 
fi 
if command -v nginx &> /dev/null; then 
	echo "Nginx is installed"
else 
	echo "Nginx is not installed. Install nginx please"
	exit 1
fi
if [ -d "$WEB_ROOT" ]; then 
	echo "Web root already exist"
else
	echo "Creating web root" 
	mkdir -p "$WEB_ROOT"
fi
if [ -f "$WEB_ROOT/index.html" ]; then 
	echo "index.html already exists"
else
cat << EOF> "$WEB_ROOT/index.html"
<!DOCTYPE html>
<html>
<head>
	<title>WELCOME TO $SITE_NAME</title>
</head>
<body> 
	<h1> Success ! $SITE_NAME is set up. </h1>
</body>
</html>
EOF
fi

cat << EOF > /etc/nginx/sites-available/$SITE_NAME
server {
    listen 80;
    server_name $SITE_NAME;
    root $WEB_ROOT;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
#LAYER 3: Enable the site
ln -sf /etc/nginx/sites-available/$SITE_NAME /etc/nginx/sites-enabled/$SITE_NAME

echo "Testing nginx configuration..."
nginx -t

echo "Reloading nginx..."
systemctl reload nginx

#LAYER 4: Confirm
echo "Site $SITE_NAME is live at http://$SITE_NAME"
echo "Web root: $WEB_ROOT"
