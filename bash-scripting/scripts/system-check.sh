#!/bin/bash

echo "=== System Check ==="

# Check internet connectivity
ping -c 1 google.com > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Internet: Connected ✓"
else
    echo "Internet: Not connected ✗"
fi

# Check if SSH service is running
systemctl is-active ssh > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "SSH Service: Running ✓"
else
    echo "SSH Service: Not running ✗"
fi

# Check disk usage
DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ $DISK -gt 80 ]; then
    echo "Disk Usage: WARNING - ${DISK}% used ✗"
else
    echo "Disk Usage: OK - ${DISK}% used ✓"
fi

# Check available memory
MEM=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ $MEM -gt 80 ]; then
    echo "Memory Usage: WARNING - ${MEM}% used ✗"
else
    echo "Memory Usage: OK - ${MEM}% used ✓"
fi

echo "=== Check Complete ==="
