{ ... }:
{
  nix-config.apps.git = {
    home =
      { ... }:
      {
        programs.git = {
          enable = true;
        };
      };
    tags = [
      "scm"
      "github"
    ];
  };
}
