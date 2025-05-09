# Git Add & Commit
gquick() {
  if [ -z "$1" ]; then
    echo "[!] Error: Please provide a commit message"
    echo "    Usage: gquick \"Your commit message\""
    return 1
  fi

  if [ -z "$(git status --porcelain)" ]; then
    echo "[!] No changes to commit"
    return 0
  fi

  # Confirm before committing
  echo -n "Are you sure you want to stage and commit changes? (y/N): "
  read response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "[!] Aborted"
    return 1
  fi

  echo "==> Staging all changes..."
  git add .

  echo "==> Committing changes..."
  if git commit -m "$1"; then
    echo "✔ Commit successful: $1"
  else
    echo "[!] Commit failed"
    return 1
  fi
}

# Git Push to All Remotes
gpush() {
  if [ -z "$1" ]; then
    echo "[!] Error: Please specify a branch name (e.g., gpush main)"
    return 1
  fi

  local branch="$1"
  local github_remotes=()
  local gitlab_remotes=()
  local detected_platforms=()

  echo "==> Scanning for Git remotes..."
  
  for remote in $(git remote); do
    local url=$(git remote get-url "$remote")
    if [[ "$url" == *"github.com"* ]]; then
      github_remotes+=("$remote")
      detected_platforms+=("GitHub")
    elif [[ "$url" == *"gitlab.com"* ]]; then
      gitlab_remotes+=("$remote")
      detected_platforms+=("GitLab")
    fi
  done

  case ${#detected_platforms[@]} in
    0)
      echo "[!] Error: No GitHub/GitLab remotes found!"
      echo "    Add one with: git remote add <name> <url>"
      return 1
      ;;
    *)
      echo "==> Detected: ${(j:, :)detected_platforms}"
      ;;
  esac

  # Confirm before pushing
  echo -n "Are you sure you want to push changes to all remotes? (y/N): "
  read response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "[!] Aborted"
    return 1
  fi

  echo "\n==> Pushing to remote repositories..."
  for remote in "${github_remotes[@]}" "${gitlab_remotes[@]}"; do
    echo "\n  >> Checking $remote/$branch"
    
    if ! git ls-remote --exit-code "$remote" "$branch" &>/dev/null; then
      echo "  ➔ Creating new branch on $remote..."
    else
      local local_commit=$(git rev-parse HEAD)
      local remote_commit=$(git rev-parse "refs/remotes/$remote/$branch" 2>/dev/null)
      
      if [ "$local_commit" = "$remote_commit" ]; then
        echo "  ✔ Already up-to-date: $remote/$branch"
        continue
      fi
    fi

    echo "  ➔ Pushing to $remote..."
    if git push "$remote" "$branch"; then
      echo "  ✔ Success: $remote/$branch"
    else
      echo "  ✖ Failed: $remote/$branch"
    fi
  done

  echo "\n==> Push process completed."
}

# Git Checkout or Create Branch
gbranch() {
  if [ -z "$1" ]; then
    echo "[!] Error: Please provide a branch name"
    echo "    Usage: gbranch <branch-name>"
    return 1
  fi
  local branch="$1"
  
  # Check if the branch exists locally first
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    local branch_exists=true
    echo "Local branch '$branch' exists."
    echo -n "Switch to existing branch? (y/N): "
  else
    local branch_exists=false
    echo "No local branch '$branch' exists."
    echo -n "Create and switch to new branch? (y/N): "
  fi
  
  # Get confirmation
  read response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "[!] Aborted"
    return 1
  fi
  
  # Perform the checkout based on branch existence
  if [ "$branch_exists" = true ]; then
    echo "==> Checking out existing branch: $branch"
    git checkout "$branch"
  else
    echo "==> Creating and checking out new branch: $branch"
    git checkout -b "$branch"
  fi
}

# Git Delete Branch (Local & Remote)
gdelete() {
  if [ -z "$1" ]; then
    echo "[!] Error: Please provide a branch name"
    echo "    Usage: gdelete <branch-name>"
    return 1
  fi

  local branch="$1"

  # Confirm before deleting
  echo -n "Are you sure you want to delete branch '$branch' locally and remotely? (y/N): "
  read response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "[!] Aborted"
    return 1
  fi

  # Delete local branch if it exists
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "==> Deleting local branch: $branch"
    git branch -D "$branch"
  else
    echo "[!] Local branch '$branch' not found"
  fi

  # Delete remote branch if it exists
  for remote in $(git remote); do
    if git ls-remote --exit-code "$remote" "$branch" &>/dev/null; then
      echo "==> Deleting remote branch: $remote/$branch"
      git push "$remote" --delete "$branch"
    else
      echo "[!] Remote branch '$branch' not found on $remote"
    fi
  done
}
