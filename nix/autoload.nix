{ lib, ... }:
let
  # Check if a file contains nix-config.apps or nix-config.hosts
  hasNixConfig = file:
    let
      content = builtins.readFile file;
    in
    builtins.match ".*nix-config\\.(apps|hosts).*" content != null;

  # Recursively collect nix-config sources with cycle protection
  collectNixConfigs = startDir:
    let
      # Helper function with visited tracking
      collectWithVisited = dir: visited:
        let
          dirStr = toString dir;
        in
        # Prevent infinite recursion by tracking visited directories
        if builtins.elem dirStr visited then [ ]
        else
          let
            entries = builtins.readDir dir;
            newVisited = visited ++ [ dirStr ];
          in
          lib.concatMap
            (name:
              let
                path = dir + "/${name}";
                entry = entries.${name};
              in
              if entry == "directory" then
                let
                  defaultPath = path + "/default.nix";
                in
                # Check if directory has default.nix with nix-config
                if builtins.pathExists defaultPath && hasNixConfig defaultPath then [
                  path
                ]
                # Otherwise recurse into subdirectories
                else
                  collectWithVisited path newVisited
              else if entry == "regular" && lib.hasSuffix ".nix" name then
                if hasNixConfig path then [
                  path
                ]
                else [ ]
              else [ ]
            )
            (builtins.attrNames entries);
    in
    collectWithVisited startDir [ ];
in
{
  imports = [ ./defaultTags.nix ] ++ (collectNixConfigs ./apps) ++ (collectNixConfigs ./hosts);
}
