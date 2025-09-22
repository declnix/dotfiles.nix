# @auto-import
{ inputs, ... }:
{
  nix-config.apps.nvf = {
    home =
      { pkgs, ... }:
      {
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

              lazy.plugins.neo-tree-nvim = {
                keys = [
                  {
                    key = "<leader>e";
                    mode = [ "n" ];
                    action = ":Neotree source=filesystem reveal=true position=left <CR>";
                  }
                ];
              };

              "fzf-lua".enable = true;

              viAlias = true;
              vimAlias = true;

              filetree.neo-tree.enable = true;

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

    tags = [ "editor" ];
  };

  nix-config.modules.home-manager = [
    inputs.nvf.homeManagerModules.default
  ];
}
