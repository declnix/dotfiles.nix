# @auto-import
{ lib, ... }:
{
  nix-config.apps.devbox = {
    home =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ devbox ];
      };

    tags = [ "devbox" ];
  };
}
