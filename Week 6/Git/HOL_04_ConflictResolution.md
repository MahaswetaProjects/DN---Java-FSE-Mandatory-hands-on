# HOL 4: Merge Conflict Resolution

## Step 1: Verify Master is Clean
```bash
git checkout master
git status
# Should show: nothing to commit, working tree clean
```

## Step 2: Create Branch and Add File
```bash
git branch GitWork
git checkout GitWork

# Add hello.xml to branch
echo "<hello>Hello from GitWork branch</hello>" > hello.xml
git add hello.xml
git commit -m "Added hello.xml in GitWork branch"

git status
```

## Step 3: Update master with DIFFERENT Content in Same File
```bash
git checkout master

# Add DIFFERENT content to hello.xml on master
echo "<hello>Hello from master branch</hello>" > hello.xml
git add hello.xml
git commit -m "Added hello.xml in master with different content"

# Observe diverged log
git log --oneline --graph --decorate --all
```

## Step 4: See the Differences
```bash
# Command line diff
git diff master GitWork

# Visual diff with P4Merge
git difftool master GitWork
```

## Step 5: Merge and See Conflict
```bash
git merge GitWork
# Git will report CONFLICT in hello.xml
```

## hello.xml will look like this after conflict:
```xml
<<<<<<< HEAD
<hello>Hello from master branch</hello>
=======
<hello>Hello from GitWork branch</hello>
>>>>>>> GitWork
```

## Step 6: Resolve Conflict
```bash
# Option 1: Use 3-way merge tool (P4Merge)
git mergetool

# Option 2: Manually edit hello.xml, keep the correct content:
# <hello>Hello from both branches - resolved</hello>

# After resolving, stage the file
git add hello.xml

# Commit the resolved merge
git commit -m "Resolved merge conflict in hello.xml"
```

## Step 7: Clean Up
```bash
# Add backup file created by mergetool to .gitignore
echo "*.orig" >> .gitignore
git add .gitignore
git commit -m "Ignore .orig backup files from mergetool"

# List branches
git branch -a

# Delete merged branch
git branch -d GitWork

# Final log
git log --oneline --graph --decorate
```
