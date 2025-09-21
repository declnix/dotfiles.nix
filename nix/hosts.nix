{ pkgs, lib, ... }:
let
  findNixConfigHosts =
    dir:
    let
      entries = builtins.attrNames (builtins.readDir dir);
      results = lib.concatMap (
        name:
        let
          path = "${dir}/${name}";
          entry = (builtins.readDir dir)."${name}";
        in
        if entry == "directory" then
          let
            files = builtins.attrNames (builtins.readDir path);
          in
          if lib.elem "default.nix" files then
            # treat directory with default.nix as host
            [ path ]
          else
            findNixConfigHosts path
        else if lib.hasSuffix ".nix" name then
          # single nix file host
          [ path ]
        else
          [ ]
      ) entries;
    in
    results;
in
{
  imports = findNixConfigHosts ./hosts;
}
