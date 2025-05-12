{
  description = "Savory nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config = {
        allowUnfree = true;
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          neovim
          tmux
          mkalias
          bun
          docker
          fzf
          git
          lazygit
          gnumake
          nodejs
          pnpm
          starship
          stylua
          tree-sitter
          zsh
          oh-my-zsh 
          bat
          curl
          stow
          lazydocker
          tree
          eza
          zoxide
          sqlite
          dotenvx
          wget
          rbenv
          ripgrep
          cocoapods
          rustup
          go
          xh
          atac
          age
      ];
      
      homebrew = {
          enable = true;

          # All CLI formulae you had under `brew list --formula`
          brews = [
            "zsh-autosuggestions" 
            "zsh-syntax-highlighting"
            "wrangler"
            "cloudflared"
          ];

          # All GUI apps / fonts you had under `brew list --cask`
          casks = [
            "font-caskaydia-cove-nerd-font"
            "font-caskaydia-mono-nerd-font"
            "font-jetbrains-mono-nerd-font"
            "ngrok"
            "ghostty"
            "raycast"
            "rectangle"
            "visual-studio-code"
            "google-chrome"
            "obsidian"
          ];

          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
      };

      fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
        ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      system.defaults = {
          dock.autohide = true;
        };

      # turn on nix & its daemon
      nix.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#savory
    darwinConfigurations."savory" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration 
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple silicon only
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "sourav";

              autoMigrate = true;
            };
          }
        ];
    };

    darwinPackages = self.darwinConfigurations."savory".pkgs;
  };
}
