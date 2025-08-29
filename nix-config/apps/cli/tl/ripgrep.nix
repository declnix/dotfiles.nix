{
  nix-config.apps.ripgrep = {
    home = {
      programs.ripgrep = {
        enable = true;
      };
    };

    tags = [
      "tl"
      "default"
    ];
  };
}
