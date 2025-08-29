{ lib, ... }:
{
  nix-config.apps.opencode = {
    home =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ opencode ];
      };

    tags = [ "ai" ];
  };
}
