# HOL 2: .gitignore — Ignoring Unwanted Files

## Objective
Ignore all .log files and any folder named "log" so they never get committed.

## Step 1: Create files that should be ignored
```bash
cd GitDemo

# Create a .log file
echo "This is a log file" > error.log

# Create a log folder with a file inside
mkdir logs
echo "log entry" > logs/app.log

# Check status - both are shown as untracked
git status
```

## Step 2: Create .gitignore
```bash
# Create the .gitignore file
touch .gitignore
```

## .gitignore (file content)
```
# Ignore all .log files
*.log

# Ignore any folder named logs
logs/

# Ignore OS generated files
.DS_Store
Thumbs.db
```

## Step 3: Stage and commit .gitignore
```bash
git add .gitignore
git commit -m "Added .gitignore to exclude .log files and logs folder"

# Verify - error.log and logs/ are no longer shown
git status
# Output should show: nothing to commit, working tree clean
```

## Step 4: Verify ignored files are not tracked
```bash
# This should show nothing (ignored files not listed)
git ls-files --others --ignored --exclude-standard

# Push to remote
git push origin master
```
