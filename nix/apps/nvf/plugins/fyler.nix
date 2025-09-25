{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    extraPlugins = {
      fyler-nvim = {
        package = pkgs.vimPlugins.fyler-nvim;
        setup = ''
          require('fyler').setup {};
        '';
      };
    };

    keymaps = [
      {
        key = "<leader>e";
        mode = [ "n" ];
        action = ":Fyler kind=float<CR>";
      }
    ];
  };
}
