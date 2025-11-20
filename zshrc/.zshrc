# ============================================================================
# ENVIRONMENT SETUP
# ============================================================================

# --- Nix ---
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# --- Homebrew setup ---
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ============================================================================
# PLUGIN MANAGER (Zinit)
# ============================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# --- Zinit plugins ---
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light ajeetdsouza/zoxide
zinit light Aloxaf/fzf-tab

# ============================================================================
# SHELL OPTIONS & HISTORY
# ============================================================================

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/dotfiles/zshrc/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ============================================================================
# KEYBINDINGS (vi mode)
# ============================================================================

# Enable vi mode
bindkey -v

# Custom bindings for vi mode
bindkey -M viins 'jj' vi-cmd-mode  # jj to enter command mode
bindkey -M viins 'jk' vi-cmd-mode  # jk to enter command mode

# History navigation (works in both insert and command mode)
bindkey -M viins '^p' history-search-backward
bindkey -M viins '^n' history-search-forward
bindkey -M vicmd '^p' history-search-backward
bindkey -M vicmd '^n' history-search-forward

# ============================================================================
# COMPLETIONS
# ============================================================================

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-completion-opts '--ansi'
zstyle ':fzf-tab:complete:*' fzf-preview 'eza --color=always --icons $realpath'

# Docker completions
fpath+=($HOME/.docker/completions)

# ============================================================================
# PROMPT (Starship)
# ============================================================================

# Deleting zle widget for starship error fix (only if it exists)
(( ${+widgets[zle-keymap-select]} )) && zle -D zle-keymap-select

# Starship prompt
eval "$(starship init zsh)" 
export STARSHIP_CONFIG="${HOME}/dotfiles/starship/starship.toml"

# ============================================================================
# PATH MODIFICATIONS
# ============================================================================

# Node.js global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# PostgreSQL and MySQL (via Homebrew)
BREW_PREFIX="$(brew --prefix)"
export PATH="$BREW_PREFIX/libpq/bin:$PATH"
export PATH="$BREW_PREFIX/mysql-client/bin:$PATH"
unset BREW_PREFIX  # Clean up after use

# ============================================================================
# TOOL INITIALIZATIONS
# ============================================================================

# --- Node / NVM setup ---
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && echo "$HOME/.nvm" || echo "$XDG_CONFIG_HOME/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- rbenv & Ruby ---
eval "$(rbenv init - zsh)"

# --- Zoxide (directory jumper) ---
eval "$(zoxide init --cmd cd zsh)"

# --- fzf ---
eval "$(fzf --zsh)"

# --- FZF defaults ---
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'

# --- TMUX setup ---
export TMUX_TMPDIR="$HOME/.tmux-log"
[ ! -d "$TMUX_TMPDIR" ] && mkdir -p "$TMUX_TMPDIR"

# --- Editor settings ---
unset GIT_EDITOR
export VISUAL="nvim"
export EDITOR="nvim"

# --- bat theme ---
export BAT_THEME="Catppuccin Mocha"

# --- Git pager ---
export GIT_PAGER="bat --paging=always -l diff"
export PAGER="bat --paging=always -l diff"

# ============================================================================
# ALIASES (grouped by category)
# ============================================================================

# --- General utilities ---
alias cl='clear'
alias la=tree
alias cat=bat

# --- eza shortcuts ---
alias ll="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# --- Code editors ---
alias v='nvim'
alias vi='nvim'
alias vscode="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

# --- Git aliases ---
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# --- Docker shortcuts ---
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# --- Database clients ---
alias pg="pgcli"
alias sq="litecli"
alias ms="mycli"

# --- Directory navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# --- Zoxide aliases ---
alias zz="z -"
alias cd="z"

# --- aerospace ---
alias aerospace='command aerospace --config $HOME/.config/aerospace/aerospace.toml'

# --- TMUX ---
alias tmux="tmux -f $HOME/dotfiles/tmux/tmux.conf"

# --- atac (Atac CLI) ---
alias postman="atac -d ~/dotfiles/atac"

# --- Darwin rebuild ---
alias rebuild="sudo darwin-rebuild switch --flake ~/dotfiles/nix#savory"

# --- tldr / help ---
if command -v tldr &> /dev/null; then
  alias help='tldr'
fi


# ============================================================================
# FUNCTIONS
# ============================================================================

# --- Yazi function (file manager with directory change) ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# --- Aerospace + fzf (window switcher) ---
ff() {
  command aerospace list-windows --all \
    | command fzf --bind 'enter:execute-silent(bash -c "aerospace focus --window-id {1}")+abort'
}

# --- Love2D ---
love() {
  # Helper function to check if it's a LÖVE2D project
  is_love_project() {
    # Check .luarc.json for "love2d"
    if [ -f ".luarc.json" ]; then
      if grep -q "love2d" ".luarc.json"; then
        return 0
      fi
    # Only check main.lua if .luarc.json doesn't exist
    elif [ -f "main.lua" ]; then
      if grep -q "love" "main.lua"; then
        return 0
      fi
    fi
    return 1
  }

  if [ "$1" = "init" ]; then
    if is_love_project; then
      echo "Error: Already in a LÖVE2D project"
      echo "Cannot initialize a new project in this directory"
      return 1
    fi
    ~/dotfiles/scripts/love_boilerplate.sh
  elif [ "$1" = "run" ]; then
    if [ -n "$2" ]; then
      /Applications/love.app/Contents/MacOS/love "$2"
    else
      if [ -f "main.lua" ] && [ -f ".luarc.json" ]; then
        /Applications/love.app/Contents/MacOS/love .
      elif [ -f "main.lua" ]; then
        echo "Warning: main.lua found but .luarc.json missing"
        /Applications/love.app/Contents/MacOS/love .
      elif [ -f ".luarc.json" ]; then
        echo "Error: .luarc.json found but main.lua missing"
      else
        echo "No love project found (main.lua and .luarc.json missing)"
      fi
    fi
  else
    /Applications/love.app/Contents/MacOS/love "$@"
  fi
}

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================

# Source local environment overrides
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
