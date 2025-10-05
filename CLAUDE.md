# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a macOS development environment using Nix-darwin for system management. The configuration includes development tools, window management, terminal setup, and application configurations.

## Key Commands

### System Management
```bash
# Rebuild Nix-darwin configuration
darwin-rebuild switch --flake ~/dotfiles/nix#savory

# Alternative rebuild command (first-time setup)
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#savory

# Apply all dotfile configurations using GNU Stow
stow .

# Initialize environment (install TPM, set up configs, reload everything)
chmod +x source.sh && ./source.sh
```

### Configuration Reloads
```bash
# Tmux
tmux source-file ~/dotfiles/tmux/tmux.conf

# AeroSpace
aerospace reload-config

# Ghostty (if supported)
ghostty reload-config

# Rebuild bat cache
bat cache --build
```

### Development Tools
- **Lua formatting**: Use `stylua` (configured in `nvim/stylua.toml`)
- **Package management**: Managed via Nix (`nix/flake.nix`)
- **Shell scripting**: Bash scripts throughout for automation

## Architecture

### Nix-darwin System (`nix/`)
- Central system configuration using Nix flakes
- Manages Homebrew casks, packages, and system settings
- Defines user applications, fonts, and development tools
- Supports both Intel and Apple Silicon Macs

### Window Management (`aerospace/`)
- AeroSpace tiling window manager configuration
- i3-inspired keybindings and workspace management
- Application-specific floating window rules
- Multi-monitor support with workspace assignments

### Terminal & Multiplexer (`tmux/`, `ghostty/`, `starship/`)
- **Tmux**: Extensive plugin ecosystem via TPM, session management, custom status bar with Catppuccin theme
- **Ghostty**: Modern terminal emulator configuration
- **Starship**: Cross-shell prompt configuration

### Development Environment (`nvim/`, `nushell/`)
- **Neovim**: Lua-based configuration with LazyVim, extensive plugin ecosystem, LSP support
- **NuShell**: Modern shell replacement with structured data support
- **Editor**: Zed editor configurations

### File Management (`yazi/`)
- Modern terminal file manager with custom themes and keybindings

### Shell Integration (`zshrc/`, `source.sh`)
- Custom Zsh configuration with ZDOTDIR setup
- Automated environment initialization script
- Tool integration and path management

## Configuration Patterns

- All configurations use modern tooling and syntax
- Heavy use of Nix flakes for reproducible environments
- Catppuccin color scheme across multiple tools
- Plugin-based architecture (tmux, nvim)
- Automation scripts for common tasks
- Git-tracked configuration with selective deployment

## File Structure Notes

- `source.sh` is the main setup script that initializes all components
- TPM (Tmux Plugin Manager) auto-installs if not present
- Configurations are organized by tool/application
- Many external plugins are vendored in `tmux/plugins/`
- Development tools are declared in `nix/flake.nix`