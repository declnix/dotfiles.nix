{
  programs.nvf.settings.vim = {
    keymaps = [
      {
        key = "<leader>ff";
        mode = [ "n" ];
        action = ":FzfLua files<CR>";
      }
    ];

    "fzf-lua".enable = true;
  };
}
