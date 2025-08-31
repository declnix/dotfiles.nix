{
  nix-config.apps.zsh = {
    home =
      { pkgs, ... }:
      {
        programs.zsh = {
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "robbyrussell";
          };

          initContent = ''
            [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
          '';

          shellAliases = {
            cat = "bat";
          };
          enable = true;
        };

        programs.fzf = {
          enable = true;
        };
        programs.eza = {
          enableZshIntegration = true;
          enable = true;
        };
        programs.bat = {
          enable = true;
        };
      };

    tags = [
      "@sh"
      "default"
    ];
  };
}
