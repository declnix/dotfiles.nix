# @auto-import
{ inputs, ... }:
{
  nix-config.apps.nixos-cli = {
    nixos = {
      services.nixos-cli = {
        enable = true;
      };
    };

    tags = [
      "nix"
      "default"
    ];
  };

  nix-config.modules.nixos = [
    inputs.nixos-cli.nixosModules.nixos-cli
  ];
}
