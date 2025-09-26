{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  modules = [
    # /imports :: grep -rl '# @nix-config-modules' | grep -E 'apps|hosts'
    apps/devbox.nix
    apps/fd.nix
    apps/git.nix
    apps/nvf/nvf.nix
    apps/eza.nix
    apps/tmux.nix
    apps/podman.nix
    apps/fzf.nix
    apps/vscode-server.nix
    apps/distrobox.nix
    apps/sudo.nix
    apps/direnv.nix
    apps/nzf.nix
    apps/gh.nix
    apps/nix-index.nix
    apps/ripgrep.nix
    apps/fonts.nix
    hosts/dreadfort/default.nix
    hosts/bealish/default.nix
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
