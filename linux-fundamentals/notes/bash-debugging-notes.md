# Bash Script Debugging

## Why Debugging Matters
Every script will break at some point. Debugging skills help you find
and fix problems quickly instead of guessing randomly.

---

## Method 1 — bash -x — Full Debug Mode
Prints every command before executing it. Your most powerful debugging tool.

```bash
# Normal run - only see output
./script.sh

# Debug run - see every command AND output
bash -x ./script.sh
```

**Reading debug output:**
```bash
+ REACHABLE=0           # + means command being executed
+ ping -c 1 google.com  # shows exact command with values
+ '[' 0 -eq 0 ']'       # shows condition being evaluated
+ echo 'google.com is reachable'
google.com is reachable  # actual output (no + prefix)
```

**Key things to spot:**
- `+` prefix means command being run
- Values inside conditions show what is being compared
- Where the + stops is where the script failed

---

## Method 2 — set -x and set +x — Partial Debug
Debug only a specific section instead of the whole script:

```bash
#!/bin/bash

echo "This runs normally"

set -x    # turn debug ON
DISK=$(df / | awk 'NR==2{print $5}' | tr -d '%')
if [ $DISK -gt 80 ]; then
    echo "Disk full"
fi
set +x    # turn debug OFF

echo "This runs normally again"
```

Use this when you know roughly where the problem is.

---

## Method 3 — Strict Mode — Catch Errors Automatically
The most important debugging tool for professional scripts.

```bash
#!/bin/bash
set -euo pipefail
```

Or separately:
```bash
set -e          # exit immediately on any error
set -u          # exit if undefined variable is used
set -o pipefail # catch failures inside pipes
```

**What each does:**

### set -e — Exit on error
```bash
#!/bin/bash
set -e

echo "Step 1"
ls /nonexistent    # this fails - script stops here
echo "Step 2"      # NEVER runs
```

Without set -e the script continues after errors — dangerous on servers.

### set -u — Catch undefined variables
```bash
#!/bin/bash
set -u

REACHABLE=0
echo $REACHEABLE    # typo in variable name

# Without set -u: prints empty string silently - hides bug
# With set -u: stops immediately with clear error message
```

Error message you will see:
```
script.sh: line 4: REACHEABLE: unbound variable
```
Tells you exactly which line and which variable.

### set -o pipefail — Catch pipe failures
```bash
# Without pipefail - shows success even though command failed
cat /nonexistent | grep "error"
echo $?    # prints 0 - WRONG and misleading

# With pipefail - correctly reports failure
set -o pipefail
cat /nonexistent | grep "error"
echo $?    # prints non-zero - CORRECT
```

---

## Method 4 — Echo Debugging — Simple but Effective
Add temporary echo lines to check variable values:

```bash
#!/bin/bash

DISK=$(df / | awk 'NR==2{print $5}' | tr -d '%')
echo "DEBUG: DISK value is $DISK"    # temporary debug line

if [ $DISK -gt 80 ]; then
    echo "Disk full"
fi
```

Remove all DEBUG lines once problem is found.

---

## Method 5 — trap ERR — Catch Errors with Line Numbers
Automatically reports which line failed:

```bash
#!/bin/bash
trap 'echo "ERROR on line $LINENO"' ERR

echo "Line works fine"
ls /nonexistent      # fails - trap fires immediately
echo "Never reached"
```

Output:
```
Line works fine
ERROR on line 5
```

Tells you exactly which line failed without hunting through the script.

---

## Common Bugs and How to Spot Them

### Bug 1 — Typo in variable name
```bash
REACHABLE=0
echo $REACHEABLE    # typo - R-E-A-C-H-E-A-B-L-E vs R-E-A-C-H-A-B-L-E

# Fix: set -u catches this immediately
# Fix: bash -x shows the empty value being used
```

### Bug 2 — Missing quotes around variables
```bash
FILE="my file.txt"
if [ -f $FILE ]; then    # wrong - space breaks the condition
if [ -f "$FILE" ]; then  # correct - quotes preserve the space
```

### Bug 3 — Wrong exit code check
```bash
ls /nonexistent
if [ $? -eq 0 ]; then    # checks ls exit code

# Bug: if you add another command between ls and if check
ls /nonexistent
echo "checking..."       # this resets $? to 0!
if [ $? -eq 0 ]; then    # now checking echo exit code - wrong!

# Fix: check $? immediately after the command
```

### Bug 4 — Forgetting command substitution
```bash
DISK=df / | awk 'NR==2{print $5}'    # wrong - treats as string
DISK=$(df / | awk 'NR==2{print $5}') # correct - runs command
```

### Bug 5 — Space in variable assignment
```bash
NAME = "Abraham"    # wrong - bash treats NAME as a command
NAME="Abraham"      # correct - no spaces around =
```

---

## Debugging Workflow

When a script fails follow this order:

```
Step 1 — Read the error message carefully
         It usually tells you the line number and what failed

Step 2 — Run with bash -x
         See exactly which command failed and what values were used

Step 3 — Add set -euo pipefail to top of script
         Catches silent errors you might have missed

Step 4 — Add echo DEBUG lines around the problem area
         Check what your variables actually contain

Step 5 — Add trap ERR to find exact line number
         When error messages are not clear enough
```

---

## Professional Script Template
Add this to the top of every script:

```bash
#!/bin/bash
# Script name:
# Description:
# Usage:
# Author:
# Date:

set -euo pipefail    # strict mode - catches silent errors

trap 'echo "ERROR: Script failed on line $LINENO"' ERR
```

This costs nothing and catches bugs before they cause damage on servers.

---

## Quick Reference Card

```
bash -x script.sh        → full debug mode
set -x                   → turn debug on at this point
set +x                   → turn debug off at this point
set -e                   → exit on any error
set -u                   → exit on undefined variable
set -o pipefail          → catch pipe failures
set -euo pipefail        → all three combined (use this always)
trap 'cmd' ERR           → run command when any error occurs
$LINENO                  → current line number
echo "DEBUG: $VAR"       → check variable value manually
```

---

## My Key Insights
- bash -x is your best friend when a script fails unexpectedly
- set -euo pipefail should be in EVERY script you write
- set -u catches typos in variable names before they cause damage
- Always check $? immediately after the command you want to test
- The + prefix in bash -x output means command being executed not output
- Where the + lines stop is exactly where your script failed
- Echo debugging is simple but never underestimate it
- Debugging skills separate junior from senior DevOps engineers
