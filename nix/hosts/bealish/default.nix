# @auto-import
{ inputs, lib, ... }:
let
  host = "bealish";
  user = "nixos";

in
{
  nix-config = {
    apps = {
      "${host}@git" = {
        home =
          { pkgs, ... }:
          {
            programs.git = {
              extraConfig = {
                credential = {
                  helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
                };
              };

              enable = true;
            };
          };

        tags = [ "${host}" ];
      };

      "${host}@zsh" = {
        nixos =
          { pkgs, ... }:
          {
            users.users.${user}.shell = pkgs.zsh;
            programs.zsh.enable = true;
          };

        tags = [ "${host}" ];
      };
    };

    hosts.${host} = {
      kind = "nixos";
      system = "x86_64-linux";

      username = user;
      homeDirectory = "/home/${user}";

      tags = {
        # ==> general groups
        development = true;
        containers = true;
        shells = true;
        utils = true;

        direnv = true;

        # ==> development tools
        distros = true;

        cli = true;
        editor = true;
        shell = true;
        wsl = true;

        # ==> ai tools
        ai = true;

        # ==> scm tools
        github = true;

        # ==> misc
        nerd-fonts = true;
        # displaylink = true;

        # ==> default apps
        default = true;

        # ==> host specific overrides
        ${host} = true;
      };

      nixos = import ./configuration.nix;
      home = import ./home.nix;
    };

    modules.nixos = [ inputs.nixos-wsl.nixosModules.wsl ];
  };
}
