# @nix-config-modules
{ inputs, ... }:
{
  nix-config.apps.vscode-server = {
    nixos =
      { pkgs, ... }:
      {
        services.vscode-server = {
          enable = true;

          installPath = [
            "$HOME/.vscode-server"
          ];

          nodejsPackage = pkgs.nodejs_24;
        };
      };

    tags = [ "wsl" ];
  };

  nix-config.modules.nixos = [
    inputs.vscode-server.nixosModules.default
  ];
}
