{
  description = "Fully modular. Infinitely replicable. Slightly overengineered – powered by Nix. ❄️";

  inputs = {
    ##############################
    # NixOS official package sources
    ##############################
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    ##############################
    # Home Manager
    ##############################
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ##############################
    # Core Flake Modules
    ##############################
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-config-modules.url = "github:chadac/nix-config-modules";

    ##############################
    # Extra Utilities & Tools
    ##############################
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nvf.url = "github:notashelf/nvf";
    nzf.url = "github:yehvaed/nzf";
    git-hooks.url = "github:cachix/git-hooks.nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs: import ./. { inherit inputs; };
}
