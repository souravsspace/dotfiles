# -- Zsh configuration file for macOS --

# --- Homebrew setup ---
if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# --- Starship prompt via Zinit ---
eval "$(starship init zsh)" 
export STARSHIP_CONFIG="${HOME}/dotfiles/starship/starship.toml"

# --- Other plugins using Zinit ---
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light junegunn/fzf
zinit light ajeetdsouza/zoxide
zinit light Aloxaf/fzf-tab

# --- vi mode ---
# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode

# Source your custom Git helper functions
source ~/dotfiles/zshrc/.git.zshrc

# --- Node / NVM setup ---
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && echo "$HOME/.nvm" || echo "$XDG_CONFIG_HOME/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- Aliases & UI tools ---
alias ll="ls -la"
alias cl='clear'
alias la=tree
export BAT_THEME="Catppuccin Mocha"
alias cat=bat

# eza shortcuts
alias ll="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# Code editors
alias vi='dotenvx run -f "$HOME/dotfiles/.env" --quiet -- nvim'
alias vscode="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias cursor="/Applications/Cursor.app/Contents/MacOS/Cursor"

# Zoxide (directory jumper)
# eval "$(zoxide init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# --- Git aliases & pager ---
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
export GIT_PAGER="bat --paging=always -l diff"
export PAGER="bat --paging=always -l diff"

# --- Docker shortcuts & completions ---
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

fpath+=(/Users/sourav/.docker/completions)
autoload -Uz compinit && compinit

# atac (Postman CLI)
alias postman="atac -d ~/dotfiles/atac"

# --- Directory aliases ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# --- Zoxide alias ---
alias cd="z"
alias zz="z -"

# --- FZF defaults ---
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'

# --- SSH config ---
export SSH_DIR="$HOME/dotfiles/ssh"
alias ssh="ssh -F $SSH_DIR/config"

# --- History & completion ---
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

autoload -Uz compinit && compinit

# --- TMUX setup ---
export TMUX_TMPDIR="$HOME/.tmux-log"
mkdir -p "$TMUX_TMPDIR"
alias tmux="tmux -f $HOME/dotfiles/tmux/tmux.conf"

# --- rbenv & Ruby ---
eval "$(rbenv init - zsh)"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# --- pnpm & Rust ---
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# --- SQLite wrapper ---
_sqlite3() {
  command sqlite3 --init "$HOME/.config/sqlite/.sqliterc" "$@"
}
alias sqlite3=_sqlite3

# --- Editor settings ---
unset GIT_EDITOR
export VISUAL="nvim"
export EDITOR="nvim"

# --- tldr / help ---
if command -v tldr &> /dev/null; then
  alias help='tldr'
fi

# --- Yazi function ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(< "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

# --- Darwin rebuild ---
alias rebuild="darwin-rebuild switch --flake ~/dotfiles/nix#savory"
