{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  modules = [
    # /imports :: grep -rl '# @auto-import' nix | sed 's|^|./|'
    ./nix/apps/devbox.nix
    ./nix/apps/fd.nix
    ./nix/apps/git.nix
    ./nix/apps/nvf/nvf.nix
    ./nix/apps/eza.nix
    ./nix/apps/tmux.nix
    ./nix/apps/podman.nix
    ./nix/apps/fzf.nix
    ./nix/apps/vscode-server.nix
    ./nix/apps/distrobox.nix
    ./nix/apps/sudo.nix
    ./nix/apps/direnv.nix
    ./nix/apps/nzf.nix
    ./nix/apps/gh.nix
    ./nix/apps/nix-index.nix
    ./nix/apps/ripgrep.nix
    ./nix/apps/fonts.nix
    ./nix/hosts/dreadfort/default.nix
    ./nix/hosts/bealish/default.nix
    ./nix/defaultTags.nix
    # /imports
  ];

  perSystem =
    {
      config,
      self',
      pkgs,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix-config";
        buildInputs =
          with pkgs;
          [
            zsh
            just
            gnumake
          ]
          ++ config.pre-commit.settings.enabledPackages;

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };

      pre-commit.settings.hooks.nixfmt-rfc-style.enable = true;

      formatter = pkgs.nixfmt-rfc-style;
    };

  flake = {
    imports = [
      inputs.nix-config-modules.flakeModule
      inputs.git-hooks.flakeModule
    ]
    ++ modules;

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
