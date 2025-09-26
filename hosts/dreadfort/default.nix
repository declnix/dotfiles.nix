# @nix-config-modules
{ lib, ... }:
{
  nix-config.hosts.dreadfort = rec {
    kind = "nixos";
    system = "x86_64-linux";

    username = "yehvaed";
    homeDirectory = "/home/${username}";

    tags = {
      # ==> apps for development
      development = true;
      containers = true;

      # ==> policies
      passwordless = true;

      # == ui, styles
      appearance = true;

      # ==> desktop
      kde = true;
    };

    nixos = import ./configuration.nix;
    home = import ./home.nix;
  };
}
