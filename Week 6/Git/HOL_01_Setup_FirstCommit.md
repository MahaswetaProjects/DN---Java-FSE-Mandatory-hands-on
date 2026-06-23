# HOL 1: Git Setup, Configuration & First Commit

## Step 1: Verify Git Installation
```bash
git --version
# Should show: git version 2.x.x
```

## Step 2: Configure Git (user level)
```bash
git config --global user.name "YourName"
git config --global user.email "youremail@example.com"

# Verify config
git config --list
```

## Step 3: Set Notepad++ as Default Editor
```bash
# Add notepad++ to PATH via Control Panel > System > Advanced > Environment Variables
# Then set as Git editor:
git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

# Verify editor is set
git config --global -e
# (-e opens the global config in the default editor)
```

## Step 4: Create Local Repository and First Commit
```bash
# Create and init repo
mkdir GitDemo
cd GitDemo
git init

# Verify hidden .git folder created
ls -la

# Create a file with content
echo "Welcome to Git" > welcome.txt

# Verify file exists
ls
cat welcome.txt

# Check status - file is untracked
git status

# Stage the file
git add welcome.txt

# Commit with multi-line message (opens editor)
git commit

# OR commit with inline message
git commit -m "Initial commit: added welcome.txt"

# Check status - working directory is clean
git status
```

## Step 5: Push to Remote GitLab/GitHub Repository
```bash
# Create a remote repo named "GitDemo" on GitLab/GitHub first, then:

git remote add origin https://github.com/YourUsername/GitDemo.git

# Pull remote (if it has a README)
git pull origin master

# Push local to remote
git push origin master
```
