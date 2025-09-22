# @auto-import
{
  nix-config.apps.ripgrep = {
    home = {
      programs.ripgrep = {
        enable = true;
      };
    };

    tags = [
      "utils"
      "cli"
    ];
  };
}
