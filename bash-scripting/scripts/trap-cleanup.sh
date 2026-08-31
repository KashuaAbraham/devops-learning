#!/bin/bash
set -euo pipefail

# ============================================
# CONFIGURATION
# ============================================
TMPFILE=/tmp/pbca-backup-$$.tmp    # $$ = current script PID
LOCKFILE=/tmp/pbca-backup.lock

# ============================================
# CLEANUP FUNCTION
# ============================================
cleanup() {
    echo "Running cleanup..."
    
    # Remove temporary file if it exists
    if [ -f $TMPFILE ]; then
        rm -f $TMPFILE
        echo "Removed temp file: $TMPFILE"
    fi
    
    # Remove lock file if it exists
    if [ -f $LOCKFILE ]; then
        rm -f $LOCKFILE
        echo "Released lock: $LOCKFILE"
    fi
    
    echo "Cleanup complete"
}

# ============================================
# TRAP - runs cleanup on ANY exit
# ============================================
trap cleanup EXIT
trap 'echo "ERROR on line $LINENO"' ERR

# ============================================
# SCRIPT LOCKING - prevent duplicate runs
# ============================================
if [ -f $LOCKFILE ]; then
    echo "ERROR: Script already running"
    exit 1
fi
touch $LOCKFILE
echo "Lock acquired: $LOCKFILE"

# ============================================
# MAIN WORK
# ============================================
echo "Creating temp file..."
touch $TMPFILE
echo "Temp file created: $TMPFILE"

echo "Doing some work..."
sleep 2

echo "Work complete!"
