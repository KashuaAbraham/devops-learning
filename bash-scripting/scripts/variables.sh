#!/bin/bash

# Defining variables - no spaces around =
NAME="Abraham"
SCHOOL="PBCA"
DATE=$(date +%Y-%m-%d)
FILES=$(ls ~ | wc -l)

# Using variables - $ prefix to read them
echo "Name: $NAME"
echo "School: $SCHOOL"
echo "Date: $DATE"
echo "Files in home: $FILES"

# Double quotes vs single quotes
echo "Hello $NAME"     # variables ARE expanded
echo 'Hello $NAME'     # variables are NOT expanded - prints literally

# Reading user input
read -p "Enter your name: " USERNAME
echo "Welcome $USERNAME!"
