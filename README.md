# Dotfiles

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

```bash
nix --version

sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist

sudo launchctl list | grep nix
```

```bash
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#sorvsys
```

```bash
darwin-rebuild switch --flake ~/dotfiles/nix#sorvsys
```

```bash
stow .
```

Claude Code config lives in the `claude/` package and targets `$HOME` instead of `~/.config`; run it from outside the repo:

```bash
cd ~ && stow --dir ~/dotfiles --target ~ claude
```

```bash
source ~/dotfiles/zshrc/.zshrc
```

```bash
chmod +x ./scripts/source.sh
./scripts/source.sh
```