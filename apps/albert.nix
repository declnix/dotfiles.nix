# @nix-config-modules
{ lib, ... }:
{
  nix-config.apps.albert = {
    enable = false;
    home =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ albert ];
      };

    nixpkgs = {
      packages.unfree = [ "albert" ];
    };
  };
}
