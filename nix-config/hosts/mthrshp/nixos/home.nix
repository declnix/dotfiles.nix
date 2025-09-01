{ ... }:
{
  programs.nvf = {
    settings = {
      vim.languages = {
        nix.enable = true;
      };
    };
  };

  home.stateVersion = "24.05";
}
