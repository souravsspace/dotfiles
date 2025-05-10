#!/usr/bin/env bash
set -euo pipefail

# Function to install Nix
install_nix() {
    if ! command -v nix-env >/dev/null 2>&1; then
        echo "🛠 Installing Nix package manager..."
        sh <(curl -L https://nixos.org/nix/install) --daemon
        # Source nix environment
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
    else
        echo "✅ Nix already installed"
    fi
}

# Function to setup nix-darwin
setup_darwin() {
    if ! command -v darwin-rebuild >/dev/null 2>&1; then
        echo "🛠 Installing nix-darwin..."
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        yes | ./result/bin/darwin-installer
    else
        echo "✅ nix-darwin already installed"
    fi
}

# Function to install Stow
install_stow() {
    if ! command -v stow >/dev/null 2>&1; then
        echo "🛠 Installing GNU Stow..."
        nix-env -iA nixpkgs.stow
    else
        echo "✅ Stow already installed"
    fi
}

# Main execution sequence
echo "🚀 Starting macOS bootstrap process"

install_nix
setup_darwin
install_stow

echo "🔗 Stowing dotfiles..."
stow . --verbose=2

echo "🔨 Building nix-darwin configuration from flake..."
darwin-rebuild switch --flake ~/dotfiles/nix#savory

echo "🎉 Bootstrap complete! Your Mac is now configured."
