{
  programs.nvf.settings.vim = {
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
  };
}
