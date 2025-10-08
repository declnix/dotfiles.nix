# @nix-config-modules @impure
let
  # Use proxy settings from the shell environment at evaluation time.
  # These must be exported before running `nixos-rebuild`.
  httpProxy = builtins.getEnv "http_proxy";
  httpsProxy = builtins.getEnv "https_proxy";
  noProxy = builtins.getEnv "no_proxy";
in
{
  nix-config.apps.proxy = {
    nixos =
      { host, ... }:
      {
        # Global environment variables for proxy
        environment.variables = {
          http_proxy = httpProxy;
          https_proxy = httpsProxy;
          no_proxy = noProxy;
        };

        networking.proxy = {
          inherit httpProxy httpsProxy;
        };

        systemd.services."nix-daemon".environment = {
          HTTP_PROXY = httpProxy;
          HTTPS_PROXY = httpsProxy;
          NO_PROXY = noProxy;
        };
      };

    tags = [ "proxy" ];
  };
}
