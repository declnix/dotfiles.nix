{ inputs, ... }:
let
  inherit (inputs) flake-parts;

  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix-config";
        buildInputs = with pkgs; [
          nixfmt-rfc-style
          lefthook
          gnumake
          zsh
        ];

        shellHook = ''
          # Run lefthook install only once per shell session
          if [[ -d .git && -f .lefthook.yml && -z "$_LEFTHOOK_INSTALLED" ]]; then
            export _LEFTHOOK_INSTALLED=1
            lefthook install
          fi
        '';
      };
    };

  flake = {
    imports = [
      inputs.nix-config-modules.flakeModule

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

      ./nix/defaultTags.nix

      # ==> hosts
      ./nix/hosts/mthrshp
    ];

    nix-config.homeApps = [ ];

    inherit perSystem;

    systems = [ "x86_64-linux" ];
  };

in
flake-parts.lib.mkFlake { inherit inputs; } flake // flake
