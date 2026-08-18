#!/bin/bash
# Script that checks services

check_service() {
    systemctl is-active --quiet $1
    if [ $? -eq 0 ]; then
        echo "$1 is running"
    else
        echo "$1 is NOT running"
    fi
}
check_service nginx
check_service ssh
check_service apache2

