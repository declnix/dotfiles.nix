{ lib, ... }:
{
  nix-config.apps.opencode = {
    home =
      { pkgs, ... }:
      {
        home.file.".config/opencode".source = ./.;
        home.packages = with pkgs; [ opencode ];
      };

    tags = [ "ai" ];
  };
}
