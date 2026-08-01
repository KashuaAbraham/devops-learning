# Git Cheatsheet

## Initial Setup
git config --global user.name "Abraham"      # set your name
git config --global user.email "you@email"   # set your email
git config --global init.defaultBranch main  # set default branch
git config --global pull.rebase false        # set merge as pull strategy
git config --list                            # verify all config

## Starting a Repository
git init                    # create new repo in current folder
git clone <url>             # copy an existing repo from GitHub

## Daily Workflow
git status                  # see what has changed - run this constantly
git diff                    # see exact line changes (+ added, - removed)
git diff --staged           # see staged changes ready to commit
git add .                   # stage all changes
git add file.txt            # stage a specific file only
git commit -m "message"     # permanently save staged changes
git push                    # send commits to GitHub
git pull                    # get latest changes from GitHub

## Viewing History
git log                     # full detailed commit history
git log --oneline           # clean one line per commit view
git show <hash>             # see what changed in a specific commit

## Branching
git branch                  # show current branch
git branch -m main          # rename branch to main
git checkout -b feature     # create and switch to new branch
git checkout main           # switch back to main
git merge feature           # merge branch into current branch
git branch -d feature       # delete branch after merging

## Connecting to GitHub
git remote add origin <url> # connect local repo to GitHub
git remote -v               # verify remote connection
git push -u origin main     # first push, sets upstream tracking
git push                    # all subsequent pushes

## Resolving Merge Conflicts
# 1. git pull triggers conflict
# 2. open conflicted file - look for markers:
#    <<<<<<< HEAD
#    your local version
#    =======
#    github version
#    >>>>>>> origin/main
# 3. remove markers, keep/edit final version
# 4. git add .
# 5. git commit -m "resolve merge conflict"
# 6. git push

## The Three States
# Untracked → Staged → Committed
#            git add   git commit

## The Golden Rule
# git pull → edit files → git add → git commit → git push
# ALWAYS pull before pushing

## Good Commit Message Examples
git commit -m "add nginx configuration for web server"
git commit -m "fix backup script permissions issue"
git commit -m "update README with git module notes"
git commit -m "resolve merge conflict in README"
# Start with a verb, be specific, keep under 72 characters

## Emergency Commands
git checkout -- file.txt    # discard changes to a file
git reset HEAD file.txt     # unstage a file
git revert <hash>           # undo a commit safely
