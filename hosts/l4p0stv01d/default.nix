# @nix-config-modules @proxy
{ inputs, lib, ... }:
{
  nix-config.hosts.l4p0stv01d = rec {
    kind = "nixos";
    system = "x86_64-linux";

    username = "nixos";
    homeDirectory = "/home/${username}";

    tags = {
      # ==> apps for development
      development = true;
      containers = true;

      # ==> policies
      passwordless = true;

      # == ui, styles
      appearance = true;

      # ==> misc
      wsl = true;
      proxy = true;
    };

    nix-config.apps = {
      nvf.enable = false;
    };

    networking = {
      httpProxy = "http://192.168.16.1:9000";
      httpsProxy = "http://192.168.16.1:9000";
      noProxy = "127.0.0.1,localhost,intra.laposte.fr,gitlab.net.extra.laposte.fr";
    };

    nixos = import ./configuration.nix;
    home = import ./home.nix;
  };

  nix-config.modules.nixos = [ inputs.nixos-wsl.nixosModules.wsl ];
}
