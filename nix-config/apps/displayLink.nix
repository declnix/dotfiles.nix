{ ... }:

{
  nix-config.apps.displaylink = {
    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:

      let
        displaylinkSource = pkgs.fetchurl {
          url = "https://www.synaptics.com/sites/default/files/exe_files/2024-10/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.1-EXE.zip";
          sha256 = "1b3w7gxz54lp0hglsfwm5ln93nrpppjqg5sfszrxpw4qgynib624";
          name = "displaylink-610.zip";
        };

        myDisplaylink = pkgs.displaylink.overrideAttrs (old: {
          src = displaylinkSource;
          meta = old.meta // {
            license = pkgs.lib.licenses.unfree;
            platforms = [ "x86_64-linux" ];
          };
        });
      in
      {

        environment.systemPackages = [ myDisplaylink ];

        services.xserver.videoDrivers = [
          "displaylink"
          "modesetting"
        ];

        services.xserver.displayManager.sessionCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
        '';
      };

    nixpkgs = {
      packages.unfree = [ "displaylink" ];
    };

    tags = [
      "displaylink"
      "usb"
      "dock"
    ];
  };

}
