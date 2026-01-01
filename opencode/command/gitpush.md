---
description: Stage all changes, commit with a descriptive message based on the diff, and push to the current branch.
agent: build
permission:
  bash:
    git add: ask
    git commit: ask
    git push: ask
---

# Please perform the following steps to save and push my work

1. **Stage Changes**
   - Run `git add .` to stage all modified and new files.

2. **Commit**
   - Analyze the staged changes to understand what has been modified.
   - Generate a concise, descriptive commit message that summarizes the specific changes (e.g., "Fix login bug", "Add user profile component", "Update README").
   - Run `git commit -m "Your generated message"`.

3. **Push**
   - Identify the current branch.
   - Run `git push origin <current_branch>`.
