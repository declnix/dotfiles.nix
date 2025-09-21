{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  perSystem =
    { config
    , pkgs
    , system
    , ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix-config";
        buildInputs =
          with pkgs;
          [
            gnumake
            zsh
          ]
          ++ config.pre-commit.settings.enabledPackages;

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };

      pre-commit.settings.hooks.nixfmt-rfc-style.enable = true;
    };

  flake = {
    imports = [
      inputs.nix-config-modules.flakeModule
      inputs.git-hooks.flakeModule

      # ==> apps
      ./nix/apps/devbox.nix
      ./nix/apps/direnv.nix
      ./nix/apps/distrobox.nix
      ./nix/apps/eza.nix
      ./nix/apps/fd.nix
      ./nix/apps/fonts.nix
      ./nix/apps/fzf.nix
      ./nix/apps/gh.nix
      ./nix/apps/git.nix
      ./nix/apps/nix-index.nix
      ./nix/apps/nixos-cli.nix
      ./nix/apps/nzf.nix
      ./nix/apps/podman.nix
      ./nix/apps/ripgrep.nix
      ./nix/apps/sudo.nix
      ./nix/apps/tmux.nix
      ./nix/apps/nvf
      # ./nix/apps.nix

      ./nix/defaultTags.nix

      # ==> hosts
      ./nix/hosts/blackout
      # ./nix/hosts/hosts.nix
    ];

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
