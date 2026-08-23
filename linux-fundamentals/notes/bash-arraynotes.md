# Bash Arrays

## What is an Array?
A variable that stores **multiple values** instead of just one:

```bash
# Regular variable - one value
SERVER="web01"

# Array - multiple values
SERVERS=("web01" "web02" "web03" "db01")
```

---

## Defining an Array
```bash
# Method 1 - all at once
SERVERS=("web01" "web02" "web03" "db01")

# Method 2 - one at a time
SERVERS[0]="web01"
SERVERS[1]="web02"
SERVERS[2]="web03"

# Method 3 - empty array then add
SERVERS=()
SERVERS+=("web01")
SERVERS+=("web02")
```

---

## Accessing Elements
```bash
SERVERS=("web01" "web02" "web03" "db01")

echo ${SERVERS[0]}      # web01 (first element)
echo ${SERVERS[1]}      # web02 (second element)
echo ${SERVERS[2]}      # web03 (third element)
echo ${SERVERS[-1]}     # db01  (last element)
echo ${SERVERS[@]}      # web01 web02 web03 db01 (ALL elements)
echo ${#SERVERS[@]}     # 4 (number of elements)
echo ${!SERVERS[@]}     # 0 1 2 3 (index numbers)
```

**Important — counting starts at 0:**
```
SERVERS[0] = web01
SERVERS[1] = web02
SERVERS[2] = web03
SERVERS[3] = db01
```

---

## Adding Elements
```bash
SERVERS=("web01" "web02")

# Add to end
SERVERS+=("web03")
echo ${SERVERS[@]}      # web01 web02 web03

# Add multiple at once
SERVERS+=("db01" "db02")
echo ${SERVERS[@]}      # web01 web02 web03 db01 db02

# Add at specific index
SERVERS[5]="cache01"
```

---

## Removing Elements
```bash
SERVERS=("web01" "web02" "web03" "db01")

# Remove one element
unset SERVERS[1]
echo ${SERVERS[@]}      # web01 web03 db01 (web02 removed)

# Remove entire array
unset SERVERS
echo ${SERVERS[@]}      # empty
```

---

## Looping Through Arrays

**Loop through values:**
```bash
SERVERS=("web01" "web02" "web03")

for SERVER in ${SERVERS[@]}; do
    echo "Checking: $SERVER"
done
```

Output:
```
Checking: web01
Checking: web02
Checking: web03
```

**Loop through with index numbers:**
```bash
for i in ${!SERVERS[@]}; do
    echo "Server $i: ${SERVERS[$i]}"
done
```

Output:
```
Server 0: web01
Server 1: web02
Server 2: web03
```

---

## Counting Inside Loops
```bash
SERVERS=("web01" "web02" "web03")
COUNT=0

for SERVER in ${SERVERS[@]}; do
    COUNT=$((COUNT + 1))
    echo "Processing server $COUNT: $SERVER"
done

echo "Total servers: $COUNT"
```

---

## Real World Examples

**Check multiple servers:**
```bash
SERVERS=("google.com" "github.com" "pbca.local")

for SERVER in ${SERVERS[@]}; do
    ping -c 1 $SERVER &>/dev/null
    if [ $? -eq 0 ]; then
        echo "✓ $SERVER is reachable"
    else
        echo "✗ $SERVER is NOT reachable"
    fi
done
```

**Create multiple users:**
```bash
STAFF=("mrs_johnson" "mr_ibrahim" "miss_chen")

for USER in ${STAFF[@]}; do
    id $USER &>/dev/null
    if [ $? -eq 0 ]; then
        echo "$USER already exists"
    else
        sudo useradd -m -s /bin/bash $USER
        echo "$USER created successfully"
    fi
done
```

**Store command output in array:**
```bash
# Store all .conf files in array
CONFIG_FILES=($(ls /etc/*.conf))

echo "Found ${#CONFIG_FILES[@]} config files"

for FILE in ${CONFIG_FILES[@]}; do
    echo "Config: $FILE"
done
```

---

## Arithmetic in Arrays
```bash
# Increment a counter
COUNT=0
COUNT=$((COUNT + 1))

# Add values
TOTAL=$((TOTAL + SIZE))

# Other operations
RESULT=$((10 * 5))    # multiply
RESULT=$((100 / 4))   # divide
RESULT=$((10 % 3))    # remainder
```

---

## Quick Reference Card

```
${array[@]}        → all elements
${#array[@]}       → number of elements
${!array[@]}       → all index numbers
${array[0]}        → first element
${array[-1]}       → last element
${array[n]}        → element at index n
array+=(value)     → add to end
unset array[n]     → remove element at index n
unset array        → remove entire array
```

---

## My Key Insights
- Array index always starts at 0
- [@] means ALL elements
- ${#array[@]} counts elements — the # means length
- ${!array[@]} gives index numbers — the ! means indices
- += adds to end of array without removing existing elements
- unset removes permanently — no undo
- Arrays make scripts scalable — add more items to the array, loop handles the rest
- Always use ${array[@]} not $array — plain variable only gives first element
