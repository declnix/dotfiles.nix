# @auto-import
{ inputs, ... }:
{
  nix-config.apps.nvf = {
    home =
      { pkgs, ... }:
      {
        imports = [
          # /imports :: find . -iname '*.nix' | grep -v nvf.nix
          ./languages/markdown.nix
          # /imports
        ];

        programs.nvf = {
          settings = {
            vim = {
              lazy.plugins."fzf-lua" = {
                keys = [
                  {
                    key = "<leader>ff";
                    mode = [ "n" ];
                    action = ":FzfLua files<CR>";
                  }
                ];
              };

              "fzf-lua".enable = true;

              extraPlugins = {
                fyler-nvim = {
                  package = pkgs.vimPlugins.fyler-nvim;
                  setup = ''
                    require('fyler').setup {
                      icon_provider = "nvim_web_devicons" 
                    };
                  '';
                };
              };

              keymaps = [
                {
                  key = "<leader>e";
                  mode = [ "n" ];
                  action = ":Fyler kind=split:leftmost<CR>";
                }
              ];

              visuals.nvim-web-devicons.enable = true;

              languages = {
                enableTreesitter = true;
              };

              viAlias = true;
              vimAlias = true;

              lsp = {
                enable = true;
              };

              statusline.lualine = {
                enable = true;
                theme = "catppuccin";
              };

              tabline.nvimBufferline.enable = true;

              theme = {
                enable = true;
                name = "catppuccin";
                style = "mocha";
                transparent = false;
              };

            };
          };
          enable = true;
        };

        home.sessionVariables = {
          EDITOR = "nvim";
        };
      };

    nixos = {
      environment.variables.EDITOR = "nvim";
    };

    tags = [
      "development"
      "editors"
      "tui"
    ];

    nixpkgs = {
      params.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            fyler-nvim = (import inputs.nixpkgs-unstable { system = final.system; }).vimPlugins.fyler-nvim;
          };
        })
      ];
    };
  };

  nix-config.modules.home-manager = [
    inputs.nvf.homeManagerModules.default
  ];
}
