{
  host,
  lib,
  pkgs,
  ...
}:

let
  # Use proxy settings from the shell environment at evaluation time.
  # These must be exported before running `nixos-rebuild`.
  httpProxy = builtins.getEnv "http_proxy";
  httpsProxy = builtins.getEnv "https_proxy";
  noProxy = builtins.getEnv "no_proxy";
in

{
  users.users.${host.username}.shell = pkgs.zsh;
  programs.zsh.enable = true;

  wsl.enable = true;
  wsl.defaultUser = "${host.username}";
  programs.nix-ld.enable = true;
  networking.hostName = lib.mkForce host.name;

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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
