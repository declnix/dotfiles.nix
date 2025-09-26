# @nix-config-modules
{
  nix-config.apps.niri = {
    nixos =
      { pkgs, ... }:
      {
        programs.niri.enable = true;
        environment.systemPackages = with pkgs; [
          fuzzel
          alacritty
        ];

      };

    tags = [ "niri" ];
  };
}
