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

# 2) Write Ghostty config-file setting
GHOSTTY_DIR="$HOME/.config/ghostty"
GHOSTTY_CFG="$GHOSTTY_DIR/config"
mkdir -p "$GHOSTTY_DIR"
if ! grep -Fxq 'config-file = "~/.config/ghostty/config"' "$GHOSTTY_CFG" 2>/dev/null; then
  echo "Writing Ghostty config-file setting to $GHOSTTY_CFG"
  echo 'config-file = "~/.config/ghostty/config"' > "$GHOSTTY_CFG"
else
  echo "Ghostty config-file setting already in place"
fi

# 3) Source tmux config (after TPM install)
TMUX_CFG="$HOME/.config/tmux/tmux.conf"
if [ -f "$TMUX_CFG" ]; then
  echo "Reloading tmux config: $TMUX_CFG"
  tmux source-file "$TMUX_CFG"
  # Reload TPM plugins
  echo "Installing/updating TPM plugins"
  "$TPM_DIR/bin/install_plugins"
else
  echo "Warning: tmux config not found at $TMUX_CFG"
fi

# 4) Reload AeroSpace
if command -v aerospace >/dev/null 2>&1; then
  echo "Reloading AeroSpace configuration"
  aerospace reload-config
else
  echo "Warning: 'aerospace' command not found in PATH"
fi

# 5) Reload SketchyBar
SKETCHYBAR_RC="$HOME/.config/sketchybar/sketchybarrc"
if command -v sketchybar >/dev/null 2>&1 && [ -f "$SKETCHYBAR_RC" ]; then
  echo "Reloading SketchyBar RC: $SKETCHYBAR_RC"
  sketchybar --reload "$SKETCHYBAR_RC"
else
  echo "Warning: sketchybar command or RC file not found"
fi

# 6) Reload Ghostty (if it supports a reload command)
if command -v ghostty >/dev/null 2>&1; then
  echo "Reloading Ghostty configuration"
  ghostty reload-config || echo "ghostty reload-config failed (check Ghostty version)"
else
  echo "Warning: 'ghostty' command not found"
fi

echo "All done!"

# 7) Rebuild bat cache and reload Zsh configuration
if command -v bat >/dev/null 2>&1; then
  echo "Rebuilding bat cache"
  bat cache --build
else
  echo "Warning: 'bat' command not found"
fi

ZSHRC="$HOME/.config/zshrc/.zshrc"
if [ -f "$ZSHRC" ]; then
  echo "Reloading Zsh configuration: $ZSHRC"
  source "$ZSHRC"
else
  echo "Warning: Zshrc file not found at $ZSHRC"
fi

echo "All done!"
