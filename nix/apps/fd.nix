# @nix-config-modules
{
  nix-config.apps.fd = {
    home = {
      programs.fd = {
        enable = true;
      };
    };

    tags = [
      "utils"
      "cli"
    ];
  };
}
