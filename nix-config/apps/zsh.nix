{
  nix-config.apps.zsh = {
    home =
      { pkgs, ... }:
      {
        programs.zsh = {
          plugins = [
            {
              name = "fzf-tab";
              src = pkgs.zsh-fzf-tab;
              file = "share/fzf-tab/fzf-tab.plugin.zsh";
            }
            {
              name = "zsh-fzf-history-search";
              src = pkgs.zsh-fzf-history-search;
              file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
            }
            {
              name = "F-Sy-H";
              src = pkgs.zsh-f-sy-h;
              file = "share/zsh/site-functions/F-Sy-H.plugin.zsh";
            }
          ];

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
