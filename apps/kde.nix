# @nix-config-modules
{
  nix-config.apps.kde = {
    enable = false;

    nixos =
      { pkgs, ... }:
      {
        services = {
          desktopManager.plasma6.enable = true;
          displayManager.sddm.enable = true;
          displayManager.sddm.wayland.enable = true;
        };
      };
  };
}
