{ apps, ... }: {
  users = { 
    declnix = {
      apps = { inherit (apps) fzf; };
    };
  };

  system = "x86_64-linux";
}