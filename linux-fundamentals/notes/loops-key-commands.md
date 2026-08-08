# Bash Scripting — Loops & Key Commands

---

## What is a Loop?

A loop repeats a block of commands automatically for each item in a list or until a condition is met. Instead of writing the same command 10 times, you write it once and let the loop handle the repetition.

---

## Types of Loops

### 1. For Loop — iterate over a list

**Structure:**
```bash
for VARIABLE in LIST; do
    # commands here
done
```

**Three parts to remember:**
- `VARIABLE` — temporary name for each item as loop goes through list
- `LIST` — the items to go through one by one
- `do` and `done` — mark beginning and end of what repeats

**Examples:**

```bash
# Loop over names
for STAFF in Mercy John Jonathan; do
    echo "Processing: $STAFF"
done

# Loop over numbers
for NUMBER in 1 2 3 4 5; do
    echo "Number: $NUMBER"
done

# Loop over a range
for NUMBER in {1..10}; do
    echo "Counting: $NUMBER"
done

# Loop over files
for FILE in /etc/*.conf; do
    echo "Config file: $FILE"
done

# Loop over arguments passed to script
for STAFF in $@; do
    echo "Processing: $STAFF"
done
```

---

### 2. While Loop — repeat while condition is true

**Structure:**
```bash
while [ condition ]; do
    # commands here
done
```

**Examples:**

```bash
# Count from 1 to 5
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Keep trying until server is reachable
while ! ping -c 1 google.com > /dev/null 2>&1; do
    echo "Waiting for network..."
    sleep 5
done
echo "Network is up!"
```

---

### 3. Until Loop — repeat until condition becomes true

Opposite of while — runs until condition is true:

```bash
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

---

## Loop Control Commands

```bash
break      # exit the loop immediately
continue   # skip current iteration, go to next
```

```bash
# Example of break
for NUMBER in {1..10}; do
    if [ $NUMBER -eq 5 ]; then
        echo "Stopping at 5"
        break
    fi
    echo "Number: $NUMBER"
done

# Example of continue
for NUMBER in {1..10}; do
    if [ $NUMBER -eq 5 ]; then
        continue    # skip 5, keep going
    fi
    echo "Number: $NUMBER"
done
```

---

## Reading from a File with a Loop

```bash
while IFS= read -r LINE; do
    echo "Line: $LINE"
done < filename.txt
```

Breaking that down:
- `IFS=` — prevents trimming whitespace from lines
- `read -r` — reads one line at a time, `-r` prevents backslash interpretation
- `done < filename.txt` — feeds the file into the loop

**Real world use:**
```bash
while IFS= read -r STAFF; do
    echo "Processing: $STAFF"
done < staff-list.txt
```

---

## Important Commands Used in Scripts

---

### `id` — check if a user exists

```bash
id username                          # shows UID, GID and groups if user exists
                                     # returns error if user doesn't exist
id $STAFF > /dev/null 2>&1           # silent check - use $? to see result
```

Use case: check before creating a user to avoid errors

---

### `useradd` — create a user

```bash
sudo useradd username                          # basic user creation
sudo useradd -m username                       # create with home directory
sudo useradd -m -s /bin/bash username          # with home dir and bash shell
sudo useradd -m -s /bin/bash -G sudo username  # add to sudo group
```

Flags:
- `-m` — creates home directory `/home/username`
- `-s /bin/bash` — sets default shell
- `-G groupname` — adds user to a group

---

### `userdel` — delete a user

```bash
sudo userdel username       # delete user only
sudo userdel -r username    # delete user AND home directory
```

---

### `$@` — all arguments passed to script

```bash
# Run script like this:
./pbca-users.sh Mercy John Jonathan

# Inside script $@ contains: Mercy John Jonathan
for STAFF in $@; do
    echo $STAFF
done
```

---

### `$#` — number of arguments passed

```bash
./pbca-users.sh Mercy John Jonathan
echo $#    # prints 3
```

Use case: validate that the user passed the right number of arguments:
```bash
if [ $# -eq 0 ]; then
    echo "Usage: ./script.sh stafflist.txt"
    exit 1
fi
```

---

### `read` — get user input or read a file

```bash
# Get input from user
read -p "Enter your name: " NAME
echo "Hello $NAME"

# Read a file line by line
while IFS= read -r LINE; do
    echo $LINE
done < file.txt
```

---

### `$((expression))` — arithmetic in bash

```bash
COUNT=$((COUNT + 1))    # increment by 1
TOTAL=$((5 * 10))       # multiply
HALF=$((100 / 2))       # divide
```

---

### `sleep` — pause the script

```bash
sleep 1      # pause for 1 second
sleep 5      # pause for 5 seconds
sleep 0.5    # pause for half a second
```

Use case in DevOps:
```bash
echo "Restarting nginx..."
sudo systemctl restart nginx
sleep 2
systemctl status nginx
```

---

### `exit` — stop the script

```bash
exit 0    # script finished successfully
exit 1    # script stopped due to error
```

When to use `exit 1`:
- Required file not found
- Wrong user running script
- Critical command failed
- Any time continuing would cause damage

---

### `/dev/null` — the black hole

```bash
command > /dev/null          # discard stdout
command 2> /dev/null         # discard stderr
command > /dev/null 2>&1     # discard everything
```

Use case: run a command silently and only check if it succeeded or failed using `$?`

---

## The Golden Pattern — Check Before Acting

This pattern appears in almost every professional script:

```bash
# 1. Run a command silently
id $STAFF > /dev/null 2>&1

# 2. Check if it succeeded or failed
if [ $? -eq 0 ]; then
    # it worked - thing exists
else
    # it failed - thing doesn't exist
fi
```

---

## Idempotency — The Most Important Script Property

An idempotent script produces the **same result** whether run once or 100 times. It never breaks what already works.

```bash
# Non-idempotent - crashes if user already exists
sudo useradd mercy

# Idempotent - checks first, only creates if needed
id mercy > /dev/null 2>&1
if [ $? -ne 0 ]; then
    sudo useradd mercy
fi
```

Always write idempotent scripts for production servers.

---

## Comparison Operators Reference

### Numbers:
```bash
-eq    # equal to
-ne    # not equal to
-gt    # greater than
-lt    # less than
-ge    # greater than or equal to
-le    # less than or equal to
```

### Strings:
```bash
=     # equal
!=    # not equal
-z    # is empty
-n    # is not empty
```

### Files:
```bash
-f    # is a regular file
-d    # is a directory
-e    # exists
-x    # is executable
-r    # is readable
-w    # is writable
```

---

## My Key Insights

- A loop has three parts: VARIABLE, LIST, do/done
- `$@` means "all arguments I was given when run"
- `$#` means "how many arguments I was given"
- Always redirect silent checks to `/dev/null 2>&1`
- Always use `$?` immediately after the command you want to check
- `exit 1` is a safety door — stop before making things worse
- Idempotent scripts are safe to run multiple times
- Read from a file with `while IFS= read -r LINE; do`
- `sleep` gives time for services to start before checking status
- Double quotes expand variables, single quotes print literally
- `$((expression))` is how you do arithmetic in bash
