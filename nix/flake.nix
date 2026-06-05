{
  description = "Savory nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew/a5409abd0d5013d79775d3419bcac10eacb9d8c5";

    homebrew-core = { url = "github:homebrew/homebrew-core/ea92d115d4f7b0c154d83eb36af259a5b793e900"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask/61be7295e5800e52fed5e80cf516d399f5dc909b"; flake = false; };
    homebrew-nikitabobko-tap = { url = "github:nikitabobko/homebrew-tap"; flake = false; };
    homebrew-felixkratz-formulae = { url = "github:FelixKratz/homebrew-formulae"; flake = false; };
    homebrew-cmux = { url = "github:manaflow-ai/homebrew-cmux"; flake = false; };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-nikitabobko-tap, homebrew-felixkratz-formulae, homebrew-cmux }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config = {
        allowUnfree = true;
      };

      environment.systemPackages = with pkgs; [ 
        tmux
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
        bat
        curl
        stow
        lazydocker
        tree
        eza
        zoxide
        sqlite
        wget
        rbenv
        ripgrep
        go
        tldr 
        yazi
        jq
        resvg
        markdownlint-cli
        zinit
        gh
        redis
        uv
        biome
        ollama
        yarn
        pgcli
        litecli
        lua
        jujutsu
        devbox
        python314
        nix
        gh-dash
        cocoapods
      ];

      homebrew = {
        enable = true;

        brews = [
          "cloudflared"
          "sevenzip"
          "mysql-client"
          "libpq"
          "postgresql"
          "awscli"
          "neovim"
          "gnupg"
          "pass"
        ];

        casks = [
          "font-caskaydia-cove-nerd-font"
          "font-caskaydia-mono-nerd-font"
          "font-jetbrains-mono-nerd-font"
          "font-symbols-only-nerd-font"
          "font-hack-nerd-font"
          "sf-symbols"
          "font-sf-pro"
          "ghostty"
          "visual-studio-code"
          "google-chrome"
          "obsidian"
          "orbstack"
          "raycast"
          "nikitabobko/tap/aerospace"
          "telegram-desktop"
          "zen"
          "surfshark"
          "zed"
          "webstorm"
          "figma"
          "claude"
          "whatsapp"
          "kindavim"
          "shortcat"
          "cmux"
        ];

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;
        global.autoUpdate = false;
      };

      fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
        ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/Applications" ];
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

      system.primaryUser = "sourav";


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

              mutableTaps = false;

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "nikitabobko/homebrew-tap" = homebrew-nikitabobko-tap;
                "felixkratz/homebrew-formulae" = homebrew-felixkratz-formulae;
                "manaflow-ai/homebrew-cmux" = homebrew-cmux;
              };

              extraEnv = {
                HOMEBREW_NO_AUTO_UPDATE = "1";
                HOMEBREW_NO_ENV_HINTS = "1";
              };
            };
          }
          ({ config, ... }: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          })
        ];
    };

    darwinPackages = self.darwinConfigurations."savory".pkgs;
  };
}
