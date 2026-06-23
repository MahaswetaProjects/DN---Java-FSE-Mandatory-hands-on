# HOL 3: Branching & Merging

## Step 1: Create a New Branch
```bash
git branch GitNewBranch

# List all local and remote branches (* = current branch)
git branch -a
```

## Step 2: Switch to Branch and Make Changes
```bash
git checkout GitNewBranch
# OR (modern way)
git switch GitNewBranch

# Create a file in the branch
echo "This is from GitNewBranch" > branch-feature.txt

# Stage and commit
git add branch-feature.txt
git commit -m "Added branch-feature.txt in GitNewBranch"

# Check status
git status
```

## Step 3: Switch Back to Master and Merge
```bash
git checkout master

# See differences between master and branch (command line)
git diff master GitNewBranch

# See visual differences using P4Merge tool
git difftool master GitNewBranch

# Merge branch into master
git merge GitNewBranch

# Observe log after merge
git log --oneline --graph --decorate
```

## Step 4: Delete Branch After Merge
```bash
# Delete the branch (safe - only if fully merged)
git branch -d GitNewBranch

# Verify branch is deleted
git branch -a

# Final log
git log --oneline --graph --decorate
```
