{
  nix-config.apps.distrobox = {
    home = {
      programs.distrobox = {
        enable = true;
      };
    };

    tags = [
      "cntr"
      "distros"
    ];
  };
}
