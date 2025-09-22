# @auto-import
{
  nix-config.apps.fzf = {
    home = {
      programs.fzf = {
        enable = true;
      };
    };

    tags = [ "cli" ];
  };
}
