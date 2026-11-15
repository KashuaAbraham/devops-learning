# Bash Here Documents (Heredocs)

## What is a Heredoc?
A heredoc lets you write multiple lines of text directly inside a script
without creating a separate file first.

Without heredoc (clunky):
```bash
echo "server {" > /etc/nginx/sites-available/pbca
echo "    listen 80;" >> /etc/nginx/sites-available/pbca
echo "}" >> /etc/nginx/sites-available/pbca
```

With heredoc (clean):
```bash
cat > /etc/nginx/sites-available/pbca << EOF
server {
    listen 80;
}
EOF
```

---

## Basic Syntax
```bash
command << DELIMITER
line 1
line 2
DELIMITER
```

- `<<` tells bash a heredoc is coming
- `DELIMITER` is a marker word that starts and ends the block
- `EOF` (End Of File) is the most common delimiter, but any word works
- The closing delimiter must be ALONE on its line

---

## The Closing Delimiter Rule (most common heredoc bug)
The closing `EOF` must be exactly `EOF` and nothing else on that line.

```
Wrong:  "EOF "     ← trailing space, bash never sees the end
Wrong:  " EOF"     ← leading space or tab, same problem
Wrong:  "eof"      ← different spelling from the opener
Right:  "EOF"      ← alone, at the start of the line
```

Symptoms when it is wrong:
```
warning: here-document at line 47 delimited by end-of-file (wanted `EOF')
syntax error: unexpected end of file
```

How to find hidden characters:
```bash
bash -n script.sh                 # checks syntax, runs nothing
grep -n 'EOF' script.sh | cat -A  # a correct closer shows as NN:EOF$
sed -i 's/[[:space:]]*$//' script.sh   # strips trailing spaces from every line
```
In vim, run `:set list` to show `$` at the end of each line.

Habit: type the closing EOF, press Enter straight away, never tap space.

---

## Writing a Heredoc to a File
```bash
# > creates or overwrites the file
cat > ~/config.txt << EOF
SERVER_NAME=pbca.edu
PORT=80
DATE=$(date +%Y-%m-%d)
EOF

# >> appends to the end of the file
cat >> ~/config.txt << EOF
ADMIN=abraham
EOF
```

---

## Expanded vs Literal: << EOF vs << 'EOF'

| Syntax | Variables and $(commands) | Use for |
|---|---|---|
| `<< EOF` | Expanded (replaced with values) | Config files filled with real values |
| `<< 'EOF'` | NOT expanded (written literally) | Generating scripts or templates |

```bash
cat << EOF
My home is $HOME        # prints: My home is /home/abraham
EOF

cat << 'EOF'
My home is $HOME        # prints: My home is $HOME
EOF
```

Memory aid: quotes = quiet. Bash does not touch anything.

---

## Escaping with a Backslash: \$
When using an unquoted `<< EOF`, bash expands every `$`.
If the text belongs to ANOTHER language (nginx, a generated script),
protect its dollar signs with a backslash:

```bash
cat << EOF
Site: $WEB_NAME        # bash fills this in
Cost: \$5              # written literally as $5
try_files \$uri \$uri/ =404;   # nginx keeps its own variables
EOF
```

Rule:
```
$WEB_NAME  → belongs to bash  → no backslash, bash fills it in
\$uri      → belongs to nginx → backslash, written as-is
```

Without the backslash, bash looks for a variable called uri. With
`set -u` the script stops with "uri: unbound variable". Without
`set -u` it silently writes an empty value and breaks the config.

---

## Indented Heredoc: <<-
`<<-` strips leading TABS (not spaces) so heredocs inside functions
or if blocks can be indented cleanly:

```bash
setup() {
	cat > /tmp/file.txt <<- EOF
	line one
	line two
	EOF
}
```
Only tabs are stripped. If your editor inserts spaces, it will not work.

---

## Heredoc Inside an if Block (idempotent file creation)
Do not overwrite a file that already exists:

```bash
if [[ ! -f "$WEB_ROOT/index.html" ]]; then
    cat > "$WEB_ROOT/index.html" << EOF
<!DOCTYPE html>
<html>
<head><title>Welcome to $SITE_NAME</title></head>
<body><h1>Success! $SITE_NAME is set up.</h1></body>
</html>
EOF
else
    echo "index.html already exists, leaving it alone"
fi
```
The closing EOF stays at the start of its line even inside the if block.

---

## Real World Uses

**Generate an nginx site config:**
```bash
cat > /etc/nginx/sites-available/$SITE_NAME << EOF
server {
    listen 80;
    server_name $SITE_NAME;
    root $WEB_ROOT;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
```

**Generate a script from a script:**
```bash
cat > ~/backup.sh << 'EOF'
#!/bin/bash
tar -czf /backup/backup-$(date +%Y%m%d).tar.gz /home/abraham
EOF
chmod +x ~/backup.sh
```

**Send a multi-line email:**
```bash
mail -s "PBCA Server Alert" admin@pbca.edu << EOF
Disk usage is above 80%.
Please investigate.
EOF
```

---

## Related Tools Used With the nginx Script

**Symlinks (enable a site):**
```bash
ln -s  source link     # fails if the link already exists
ln -sf source link     # -f replaces it, safe to run twice (idempotent)
```

**Test before you apply:**
```bash
nginx -t                    # check the config syntax
systemctl reload nginx      # apply it without dropping connections
```

**Checking a string pattern in [[ ]]:**
```bash
[[ "$WEB_ROOT" != /* ]]     # true when path does NOT start with /
[[ "$NAME" =~ ^[a-z0-9.-]+$ ]]   # true when only a-z, 0-9, dot, hyphen
# Variable in quotes, pattern /* NOT in quotes
# ! needs a space after it: [[ ! "$X" ... ]]
```

---

## Quick Reference Card
```
cat << EOF           → heredoc, variables expand
cat << 'EOF'         → heredoc, nothing expands
cat > file << EOF    → write heredoc into file (overwrite)
cat >> file << EOF   → append heredoc to file
<<- EOF              → strip leading tabs, allows indenting
\$                   → write a literal dollar sign
EOF alone on line    → closing delimiter, nothing before or after it
bash -n script.sh    → check syntax without running
cat -A               → reveal hidden characters (trailing spaces)
ln -sf src link      → create or replace symlink
nginx -t             → test nginx config before reloading
```

---

## My Key Insights
- The closing EOF must be alone on its line: no trailing space, no leading space
- bash -n catches syntax errors but not logic errors; only running the script does
- Unquoted << EOF expands variables; quoted << 'EOF' does not
- Use \$ for dollar signs that belong to another language like nginx
- Every nginx directive ends with a semicolon
- Guard file creation with [[ ! -f ]] so a second run never overwrites work
- ln -sf makes enabling a site safe to run twice
- Always run nginx -t before systemctl reload nginx
- When writing a variable: NAME="value", no $ and no spaces
- Test with real input and with deliberately wrong input
