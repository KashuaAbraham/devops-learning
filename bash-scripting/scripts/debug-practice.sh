#!/bin/bash
set -euo pipefail

NAME="Abraham"
echo "Hello $NAME"

# Fixed - define the variable
DEFINED_VAR="I am defined now"
echo $DEFINED_VAR

# Fixed - use a real directory
ls /etc | head -5

echo "Script completed successfully"
