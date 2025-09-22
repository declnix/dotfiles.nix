# @auto-import
{
  nix-config.apps.direnv = {
    home = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };

    tags = [
      "development"
    ];
  };
}
