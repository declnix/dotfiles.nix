# @nix-config-modules
{ lib, ... }:
let
  inherit (lib) mkOption types mkIf;

  proxyProtocolsType = types.submodule {
    options = {
      http = mkOption {
        type = types.str;
        default = "";
        description = "HTTP proxy URL for this host.";
      };
      https = mkOption {
        type = types.str;
        default = "";
        description = "HTTPS proxy URL for this host.";
      };
    };
  };

  proxyType = types.submodule {
    options = {
      enabled = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable proxy configuration.";
      };

      protocols = mkOption {
        type = proxyProtocolsType;
        default = { };
        description = "Proxy URLs per protocol.";
      };

      exclude = mkOption {
        type = types.str;
        default = "";
        description = "Comma-separated list of hosts to bypass proxying.";
      };
    };
  };

  hostType = types.submodule {
    options = {
      proxy = mkOption {
        type = proxyType;
        default = { };
        description = "Proxy configuration for this host.";
      };
    };
  };
in
{
  options = {
    nix-config.hosts = mkOption {
      type = types.attrsOf hostType;
      description = "Host definitions with optional proxy configuration.";
    };
  };

  config = {
    nix-config.apps.proxy = {
      nixos =
        { host, ... }:
        let
          inherit (host.proxy) enabled protocols bypass;
          http = protocols.http or "";
          https = protocols.https or "";
        in
        mkIf enabled {
          environment.variables = {
            http_proxy = http;
            https_proxy = https;
            no_proxy = bypass;
          };

          networking.proxy = {
            default = http;
            inherit https;
            noProxy = bypass;
          };

          systemd.services."nix-daemon".environment = {
            HTTP_PROXY = http;
            HTTPS_PROXY = https;
            NO_PROXY = bypass;
          };
        };
      tags = [ "proxy" ];
    };
  };
}
