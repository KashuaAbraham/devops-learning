#!/bin/bash

# Test a successful command
ls /etc > /dev/null
echo "ls /etc exit code: $?"

# Test a failing command
ls /nonexistent > /dev/null 2>&1
echo "ls /nonexistent exit code: $?"

# Test network connectivity
ping -c 1 google.com > /dev/null 2>&1
echo "ping google.com exit code: $?"
