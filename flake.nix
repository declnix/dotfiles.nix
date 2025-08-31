{
  description = "Fully modular. Infinitely replicable. Slightly overengineered – powered by Nix. ❄️";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-config-modules.url = "github:chadac/nix-config-modules";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cli.url = "github:nix-community/nixos-cli";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nvf.url = "github:notashelf/nvf";
    nzf.url = "github:yehvaed/nzf";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { flake-parts, nixpkgs, ... }@inputs:
    let
      # perSystem definition separated for clarity
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
              if [[ -d .git &&  -f .lefthook.yml && -z "$_LEFTHOOK_INSTALLED" ]]; then
                export _LEFTHOOK_INSTALLED=1
                lefthook install
              fi
            '';
          };
        };

      inherit (nixpkgs) lib;

      autoload = import ./. { inherit lib inputs nixpkgs; };

      flakeBody = {
        systems = [ "x86_64-linux" ];

        imports = [ inputs.nix-config-modules.flakeModule ] ++ autoload.importPaths;

        nix-config.homeApps = [ ];
        nix-config.defaultTags = autoload.tags;

        inherit perSystem;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } flakeBody;
}
