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
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#savory
```

```bash
darwin-rebuild switch --flake ~/dotfiles/nix#savory
```

```bash
stow .
```

```bash
source ~/dotfiles/zshrc/.zshrc
```

```bash
chmod +x ./scripts/source.sh
./scripts/source.sh
```