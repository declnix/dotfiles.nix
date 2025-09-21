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
      ./nix/autoload.nix
    ];

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
