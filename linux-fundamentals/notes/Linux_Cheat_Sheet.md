# Linux Cheat Sheet

## Navigation

``` bash
pwd                 # Show current directory
ls                  # List files
ls -l               # Long listing
ls -la              # Show hidden files
cd                  # Go to home directory
cd /path            # Change directory
cd ..               # Go up one level
cd -                # Previous directory
tree                # Show directory tree
```

## File Operations

``` bash
touch file.txt              # Create empty file
cp file1 file2              # Copy file
cp -r folder backup         # Copy directory recursively
mv old.txt new.txt          # Rename or move file
rm file.txt                 # Delete file
rm -r folder                # Delete directory recursively
mkdir project               # Create directory
mkdir -p a/b/c              # Create nested directories
```

## Viewing Files

``` bash
cat file.txt        # Display entire file
less file.txt       # View one page at a time
head file.txt       # First 10 lines
tail file.txt       # Last 10 lines
tail -f logfile.log # Follow log updates live
```

## Searching

``` bash
find . -name "*.txt"      # Find text files
grep "error" file.log     # Search for text
grep -r "docker" .        # Search recursively
which git                 # Show executable location
whereis docker            # Show binary/manual locations
```

## Permissions

``` bash
chmod +x script.sh              # Make executable
chmod 755 script.sh             # rwxr-xr-x permissions
chown user file.txt             # Change owner
chown -R user:group folder      # Change owner recursively
```

## Users

``` bash
whoami          # Current user
id              # User and group IDs
sudo command    # Run as administrator
passwd          # Change password
groups          # Show user groups
```

## Processes

``` bash
ps              # Running processes
ps aux          # Detailed process list
top             # Live process monitor
htop            # Better process monitor (if installed)
kill PID        # Stop process
kill -9 PID     # Force stop process
pgrep nginx     # Find process ID by name
```

## Disk

``` bash
df -h           # Filesystem usage
du -sh *        # Folder sizes
lsblk           # Block devices
mount           # Mounted filesystems
```

## Networking

``` bash
ip addr                 # IP addresses
ip route                # Routing table
ping google.com         # Connectivity test
curl https://example.com # Fetch webpage/API
wget URL                # Download file
ss -tuln                # Listening ports
```

## Archives

``` bash
tar -czf backup.tar.gz folder # Create tar.gz
tar -xzf backup.tar.gz        # Extract tar.gz
zip archive.zip file          # Create ZIP
unzip archive.zip             # Extract ZIP
```

## Packages (Ubuntu)

``` bash
sudo apt update         # Refresh package list
sudo apt upgrade        # Upgrade installed packages
sudo apt install nginx  # Install package
sudo apt remove nginx   # Remove package
apt search docker       # Search packages
```

## Services

``` bash
systemctl status nginx   # Service status
systemctl start nginx    # Start service
systemctl stop nginx     # Stop service
systemctl restart nginx  # Restart service
systemctl enable nginx   # Start on boot
systemctl disable nginx  # Disable on boot
```

## Logs

``` bash
journalctl            # System logs
journalctl -u nginx   # Logs for nginx
journalctl -f         # Follow logs live
```

## SSH

``` bash
ssh user@server                  # Connect to server
scp file.txt user@server:/tmp    # Copy file to server
ssh-keygen                       # Generate SSH key
ssh-copy-id user@server          # Install public key
```

## Git

``` bash
git status                     # Check repository status
git add .                      # Stage all changes
git commit -m "message"        # Save changes locally
git push                       # Upload commits to remote
git pull                       # Download and merge changes
git log                        # View commit history
git branch                     # List local branches
git switch branch              # Switch branch
git merge branch               # Merge branch
```

## Vim

``` text
i        Enter insert mode
Esc      Exit insert mode
:w       Save
:q       Quit
:wq      Save and quit
:q!      Quit without saving
dd       Delete line
yy       Copy line
p        Paste
u        Undo
Ctrl+r   Redo
/search  Search
n        Next search result
```

## Shell Shortcuts

``` text
Ctrl+C   Stop current process
Ctrl+Z   Suspend process
Ctrl+D   Logout / EOF
Ctrl+L   Clear screen
Ctrl+A   Beginning of line
Ctrl+E   End of line
Ctrl+R   Search command history
Tab      Auto-complete
↑         Previous command
```
