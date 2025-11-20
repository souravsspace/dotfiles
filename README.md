# Dotfiles

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/dotfiles/nix#savory\
```

```bash
darwin-rebuild switch --flake ~/dotfiles/nix#savory
```

```bash
stow.
```

```bash
chmod +x ./scripts/source.sh
./scripts/source.sh
```
