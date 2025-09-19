{ lib, config, ... }:

let
  apps = config.nix-config.apps;

  allTags = builtins.concatMap (app: app.tags or [ ]) (builtins.attrValues apps);
in
{
  nix-config.defaultTags = builtins.listToAttrs (
    map (t: {
      name = t;
      value = lib.mkDefault false;
    }) allTags
  );
}
