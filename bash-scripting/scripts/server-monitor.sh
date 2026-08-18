#!/bin/bash
# Script name: server-monitor.sh
# Description: Monitors disk, memory and nginx availability
# Usage: sudo ./server-monitor.sh
# Author: Abraham Kashua
# Date: 17th August 2026

# ============================================
# CONFIGURATION
# ============================================
DISK_THRESHOLD=80
MEMORY_THRESHOLD=80
PORT=80
CHECK_INTERVAL=30
LOGFILE=/home/abraham/devops-learning/bash-scripting/logs/monitor.log

# ============================================
# FUNCTIONS
# ============================================
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOGFILE
}

check_nginx() {
    systemctl is-active --quiet nginx
    if [ $? -eq 0 ]; then
        log_message "OK: nginx is running"
    else
        log_message "ALERT: nginx is NOT running"
    fi
}

check_disk() {
    DISK_USAGE=$(df / | awk 'NR==2{print $5}' | tr -d '%')
    if [ $DISK_USAGE -ge $DISK_THRESHOLD ]; then
        log_message "ALERT: Disk usage is ${DISK_USAGE}%"
    else
        log_message "OK: Disk usage is ${DISK_USAGE}%"
    fi
}

check_memory() {
    MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    if [ $MEMORY_USAGE -ge $MEMORY_THRESHOLD ]; then
        log_message "ALERT: Memory usage is ${MEMORY_USAGE}%"
    else
        log_message "OK: Memory usage is ${MEMORY_USAGE}%"
    fi
}
check_port() {
	nc -zv localhost $PORT &>/dev/null

	if [ $? -eq 0 ]; then 
		log_message "OK: $PORT is reachable"
	else 
		log_message "Port $PORT is NOT reachable"
	fi
}
# ============================================
# LAYER 2 - ENVIRONMENT CHECKS
# ============================================
if ! command -v nginx &>/dev/null; then
	echo "Nginx is not installed. Installing ..."
	sudo apt update 
	sudo apt install -y nginx
	if [ $? -eq 0 ]; then
	       echo "Nginx installed successfully"
       else 
	       echo "ERROR: FAiled to install nginx"
	       exit 1
	fi	       

fi 
mkdir -p /home/abraham/devops-learning/bash-scripting/logs
# ============================================
# LAYER 3 - MAIN MONITORING LOOP
# ============================================
log_message "=== Server Monitor Started ==="

while true; do
    log_message "--- Running checks ---"
    # call all four functions here
    check_nginx
    check_disk
    check_memory
    check_port
    sleep $CHECK_INTERVAL
done

