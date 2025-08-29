{
  lib,
  inputs,
  nixpkgs,
  ...
}:

let
  # Import a .nix file, calling it if it's a function
  importNixFile =
    path:
    let
      raw = import path;
    in
    if lib.isFunction raw then
      raw {
        inherit inputs lib nixpkgs;
        pkgs = nixpkgs;
        modulesPath = "";
        config = { };
      }
    else
      raw;

  # Check if a file's content has nix-config apps or hosts
  hasNixConfig =
    content:
    lib.hasAttrByPath [ "nix-config" "apps" ] content
    || lib.hasAttrByPath [ "nix-config" "hosts" ] content;

  # Discover nix-config files recursively in a directory
  discoverConfigs =
    dir:
    lib.flatten (
      lib.mapAttrsToList (
        name: type:
        let
          fullPath = "${dir}/${name}";
        in
        if type == "directory" then
          discoverConfigs fullPath
        else if lib.hasSuffix ".nix" name then
          let
            content = importNixFile fullPath;
            configPath = if name == "default.nix" && hasNixConfig content then dir else fullPath;
          in
          if hasNixConfig content then
            [
              {
                path = configPath;
                content = content;
              }
            ]
          else
            [ ]
        else
          [ ]
      ) (builtins.readDir dir)
    );

  foundConfigs = discoverConfigs ./nix-config;

  importPaths = map (c: c.path) foundConfigs;

  hostNames = lib.concatMap (c: lib.attrNames (c.content.nix-config.hosts or { })) foundConfigs;

  tags = lib.genAttrs (lib.unique (
    lib.concatMap (
      conf:
      lib.concatLists (lib.mapAttrsToList (_: app: app.tags or [ ]) (conf.content.nix-config.apps or { }))
    ) foundConfigs
  )) (_: false);

in
{
  inherit
    foundConfigs
    importPaths
    hostNames
    tags
    ;
}
