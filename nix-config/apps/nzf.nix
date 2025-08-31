{ inputs, lib, ... }:

{
  nix-config.apps.nzf = {
    home =
      { pkgs, lib, ... }:
      {
        programs.nzf = {
          plugins = with pkgs; {
            zsh-fzf-tab = rec {
              config = ''
                source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
              '';

              defer = true;

              extraPackages = [ fzf ];
            };

            zsh-fzf-history-search = {
              config = ''
                source ${zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
              '';
              
              defer = true;
              after = [ zsh-vi-mode ];

              extraPackages = [ fzf ];
            };

            zsh-f-sy-h = rec {
              config = ''
                source ${zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh
              '';
            };

            zsh-vi-mode = rec {
              config = ''
                source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
              '';
            };
          };
          enable = true;
        };
      };

    tags = [
      "@ed"
      "zsh"
      "nzf"
    ];

    enablePredicate = { host, ... }: host.tags."@ed" && host.tags.zsh;

  };

  nix-config.modules.home-manager = [
    inputs.nzf.homeManagerModules.default
  ];
}
