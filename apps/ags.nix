# @nix-config-modules
{ inputs, ... }:
let
  inherit (inputs) ags astal;
in
{
  nix-config = {
    apps.ags = {
      enable = false;

      home =
        { pkgs, ... }:
        {
          programs.ags = {
            enable = true;

            # symlink to ~/.config/ags
            configDir = ../ags;

            # # additional packages and executables to add to gjs's runtime
            # extraPackages = with pkgs; [
            #   astal.packages.${pkgs.system}.battery
            #   fzf
            # ];
          };
        };
    };

    modules = {
      home-manager = [
        ags.homeManagerModules.default
      ];
    };
  };

}
