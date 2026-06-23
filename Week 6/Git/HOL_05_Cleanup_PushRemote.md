# HOL 5: Clean Up & Push to Remote

## Step 1: Verify Master is Clean
```bash
git checkout master
git status
# Should show: nothing to commit, working tree clean
```

## Step 2: List All Branches
```bash
git branch -a
# Confirm all feature branches are deleted / merged
```

## Step 3: Pull Latest from Remote
```bash
git pull origin master
# Fetches + merges any changes from remote into local master
```

## Step 4: Push All Pending Changes to Remote
```bash
git push origin master

# If remote is ahead and you need to force (use carefully):
# git push origin master --force
```

## Step 5: Verify on Remote
```bash
# Open GitHub/GitLab in browser and confirm:
# - All commits are visible
# - Conflict resolution commit is present
# - .gitignore is updated
# - No unwanted files (.log, .orig) are in the repo
```

## Useful Final Commands Summary
```bash
git log --oneline --graph --decorate   # visual commit history
git remote -v                          # show remote URLs
git status                             # current state
git branch -a                          # all branches
git diff origin/master                 # diff local vs remote
```
