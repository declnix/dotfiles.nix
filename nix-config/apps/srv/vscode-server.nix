{ inputs, ... }:
{
  nix-config.apps.vscode-server = {
    nixos = {
      services.vscode-server.enable = true;
      services.vscode-server.enableFHS = true;
    };

    tags = [ "vscode" ];
  };

  nix-config = {
    modules.nixos = [ inputs.vscode-server.nixosModules.default ];
  };
}
