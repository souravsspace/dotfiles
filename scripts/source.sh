#!/usr/bin/env bash
set -euo pipefail

# 0) Install TPM (Tmux Plugin Manager) if not already installed
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM (Tmux Plugin Manager) to $TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed at $TPM_DIR"
fi

# 1) Ensure ~/.zshenv has the ZDOTDIR export
ZSHENV="$HOME/.zshenv"
EXPORT_LINE='export ZDOTDIR="$HOME/.config/zshrc"'
if ! grep -Fxq "$EXPORT_LINE" "$ZSHENV" 2>/dev/null; then
  echo "Adding ZDOTDIR export to $ZSHENV"
  echo "" >> "$ZSHENV"
  echo "$EXPORT_LINE" >> "$ZSHENV"
else
  echo "ZDOTDIR export already present in $ZSHENV"
fi

# 2) Source tmux config (after TPM install)
TMUX_CFG="$HOME/.config/tmux/tmux.conf"
if [ -f "$TMUX_CFG" ]; then
  echo "Reloading tmux config: $TMUX_CFG"
  tmux source-file "$TMUX_CFG"
else
  echo "Warning: tmux config not found at $TMUX_CFG"
fi

# 3) Reload AeroSpace
if command -v aerospace >/dev/null 2>&1; then
  echo "Reloading AeroSpace configuration"
  aerospace reload-config
else
  echo "Warning: 'aerospace' command not found in PATH"
fi

# 4) Ghostty auto-reloads its config file on change, nothing to do here.

# 5) Rebuild bat cache
if command -v bat >/dev/null 2>&1; then
  echo "Rebuilding bat cache"
  bat cache --build
else
  echo "Warning: 'bat' command not found"
fi

# 6) Sanity-check the Zsh configuration (this script runs as a bash
# subprocess, so it can't reload config into your interactive shell —
# run `exec zsh` or open a new terminal for that).
ZSHRC="$HOME/.config/zshrc/.zshrc"
if [ -f "$ZSHRC" ]; then
  echo "Validating Zsh configuration: $ZSHRC"
  if zsh -c "source '$ZSHRC'" 2>/tmp/zshrc-check.$$; then
    echo "Zsh config OK. Run 'exec zsh' or open a new terminal to apply it."
  else
    echo "Warning: Zsh config failed to source cleanly:"
    cat /tmp/zshrc-check.$$
  fi
  rm -f /tmp/zshrc-check.$$
else
  echo "Warning: Zshrc file not found at $ZSHRC"
fi

echo "All done!"
