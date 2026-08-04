#!/bin/bash

# Basic if/else
AGE=25

if [ $AGE -gt 18 ]; then
    echo "Adult"
else
    echo "Minor"
fi

# if/elif/else
SCORE=75

if [ $SCORE -ge 80 ]; then
    echo "Distinction"
elif [ $SCORE -ge 60 ]; then
    echo "Pass"
else
    echo "Fail"
fi
