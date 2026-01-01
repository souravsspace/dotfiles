---
description: Stage, commit, push current branch, merge to main, push main, and return to original branch.
agent: build
permission:
  bash:
    git add: ask
    git commit: ask
    git push: ask
    git checkout: ask
    git pull: ask
    git merge: ask
---

# Please perform the following steps to save, push, and merge to main

1. **Identify Branch**
   - Get the current branch name and store it (e.g., `current_branch`).

2. **Stage Changes**
   - Run `git add .` to stage all modified and new files.

3. **Commit**
   - Analyze the staged changes to understand what has been modified.
   - Generate a concise, descriptive commit message that summarizes the specific changes.
   - Run `git commit -m "Your generated message"`.

4. **Push Current Branch**
   - Run `git push origin <current_branch>`.

5. **Merge to Main**
   - Run `git checkout main`.
   - Run `git pull origin main` (to ensure main is up to date before merging).
   - Run `git merge <current_branch>`.
   - Run `git push origin main`.

6. **Return to Branch**
   - Run `git checkout <current_branch>`.
