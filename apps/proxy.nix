# @nix-config-modules
{ lib, ... }:
let
  inherit (lib) mkOption types;

  proxyType = types.submodule {
    options = {
      httpProxy = mkOption {
        type = types.str;
        default = "";
        description = "HTTP proxy URL";
      };
      httpsProxy = mkOption {
        type = types.str;
        default = "";
        description = "HTTPS proxy URL";
      };
      noProxy = mkOption {
        type = types.str;
        default = "";
        description = "Comma-separated list of hosts to exclude from proxying";
      };
    };
  };

  hostType = types.submodule {
    options = {
      networking = mkOption {
        default = { };
        type = proxyType;
      };
    };
  };
in
{
  options = {
    nix-config.hosts = mkOption {
      type = types.attrsOf hostType;
    };
  };

  config = {
    nix-config.apps.proxy = {
      nixos =
        { host, ... }:
        let
          inherit (host.networking) httpProxy httpsProxy noProxy;
        in
        {
          # Global environment variables for proxy
          environment.variables = lib.mkIf (httpProxy != "") {
            inherit httpProxy httpsProxy noProxy;
          };

          networking.proxy = lib.mkIf (httpProxy != "") {
            default = httpProxy;
            inherit httpsProxy noProxy;
          };

          systemd.services."nix-daemon".environment = lib.mkIf (httpProxy != "") {
            HTTP_PROXY = httpProxy;
            HTTPS_PROXY = httpsProxy;
            NO_PROXY = noProxy;
          };
        };
      tags = [ "proxy" ];
    };
  };
}
