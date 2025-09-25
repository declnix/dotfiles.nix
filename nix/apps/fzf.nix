# @nix-config-modules
{
  nix-config.apps.fzf = {
    home = {
      programs.fzf = {
        enable = true;
      };
    };

    tags = [
      "utils"
      "cli"
    ];
  };
}
