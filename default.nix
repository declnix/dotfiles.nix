{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  modules = [
    # @macro :: grep -rl '# @nix-config-modules' | grep -E 'apps|hosts' | sort
    apps/ags.nix
    apps/alacritty.nix
    apps/albert.nix
    apps/devbox.nix
    apps/direnv.nix
    apps/distrobox.nix
    apps/eza.nix
    apps/fd.nix
    apps/fonts.nix
    apps/fzf.nix
    apps/gh.nix
    apps/git.nix
    apps/kde.nix
    apps/lacy.nix
    apps/niri.nix
    apps/nix-index.nix
    apps/nvf/nvf.nix
    apps/nzf.nix
    apps/podman.nix
    apps/ripgrep.nix
    apps/sudo.nix
    apps/tmux.nix
    apps/vscode-server.nix
    apps/zoxide.nix
    hosts/bl4ck0ut/default.nix
    hosts/d34dsh1p/default.nix
    # @end
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
    ++ [
      (
        { lib, config, ... }:

        let
          apps = config.nix-config.apps;

          allTags = builtins.concatMap (app: app.tags or [ ]) (builtins.attrValues apps);
        in
        {
          nix-config.defaultTags = builtins.listToAttrs (
            map (t: {
              name = t;
              value = lib.mkDefault false;
            }) allTags
          );
        }
      )
    ]
    ++ modules;

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
