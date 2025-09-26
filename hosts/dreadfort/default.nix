# @nix-config-modules
{ lib, ... }:
let
  host = "dreadfort";
  user = "yehvaed";

in
{
  nix-config.apps = {
    "${host}@kde" = {
      nixos = {
        services = {
          desktopManager.plasma6.enable = true;
          displayManager.sddm.enable = true;
          displayManager.sddm.wayland.enable = true;
        };
      };

      tags = [ "${host}" ];
    };

    "${host}@zsh" = {
      nixos =
        { pkgs, ... }:
        {
          users.users.${user}.shell = pkgs.zsh;
          programs.zsh.enable = true;
        };

      tags = [ "${host}" ];
    };
  };

  nix-config.hosts.${host} = {
    tags = {
      # ==> apps for development
      development = true;
      containers = true;

      # ==> policies
      passwordless = true;

      # == ui, styles
      appearance = true;

      # ==> host specific overrides
      ${host} = true;

    };

    nixos = import ./configuration.nix;
    home = import ./home.nix;

    kind = "nixos";
    system = "x86_64-linux";

    username = user;
    homeDirectory = "/home/${user}";
  };
}
