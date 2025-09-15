{
  description = "Fully modular. Infinitely replicable. Slightly overengineered – powered by Nix. ❄️";

  inputs = {
    slices.url = "path:/home/yehvaed/@desk/nix-slices";
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

  outputs = { slices, ... }@inputs: slices ./nix { inherit inputs; };
}
