#!/bin/bash
set -euo pipefail

trap 'echo "Script finished - cleaning up"' EXIT
trap 'echo "ERROR occurred on line $LINENO"' ERR

echo "Step 1 - starting"
ls /nonexistent      # this will fail
echo "Step 2 - this never runs"
