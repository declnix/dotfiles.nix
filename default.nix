{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  modules = [
    # /imports :: grep -rl '# @nix-config-modules' | grep -E 'apps|hosts' | sort
    apps/ags.nix
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
    apps/niri.nix
    apps/nix-index.nix
    apps/nvf/nvf.nix
    apps/nzf.nix
    apps/podman.nix
    apps/ripgrep.nix
    apps/sudo.nix
    apps/tmux.nix
    apps/vscode-server.nix
    hosts/bealish/default.nix
    hosts/dreadfort/default.nix
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
      apps.eval-macros = {
        type = "app";
        program = pkgs.writeShellScriptBin "eval-macros" ''
          grep -rlE '^ *# */[^ ]* *::' . --include '*.nix' | while read -r file; do
            dir=$(dirname "$file")
            base=$(basename "$file")

            (
              cd "$dir" || exit 1
              ${pkgs.perl}/bin/perl -i -pe '
                if (/^(\s*)# \/[^ ]* :: (.*)$/) {
                  print $_;
                  $indent = $1;
                  $cmd = $2;
                  chomp($cmd);
                  @out = `$cmd`;
                  print map { "$indent$_" } @out;
                  $_ = "";
                  $in = 1;
                }
                elsif ($in && /^(\s*)# \/[^ ]*$/) {
                  $in = 0;
                  print $_;
                  $_ = "";
                }
                elsif ($in) {
                  $_ = "";
                }
              ' "$base"
            )
          done
        '';
      };
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
