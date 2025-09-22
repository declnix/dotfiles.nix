{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  perSystem =
    { config
    , self'
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
      ./imports.nix
    ];

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
