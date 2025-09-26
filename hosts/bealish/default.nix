# @nix-config-modules
{ inputs, lib, ... }:
{
  nix-config.hosts.bealish = rec {
    kind = "nixos";
    system = "x86_64-linux";

    username = "nixos";
    homeDirectory = "/home/${username}";

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
    };

    nixos = import ./configuration.nix;
    home = import ./home.nix;
  };

  nix-config.modules.nixos = [ inputs.nixos-wsl.nixosModules.wsl ];
}
