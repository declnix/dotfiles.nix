# @nix-config-modules
{ inputs, ... }:
{
  nix-config.apps.lacy = {
    enable = true;
    home =
      { pkgs, ... }:
      {
        # FIXME: programs need to add lacy package to home packages
        # programs.lacy = {
        #   enable = true;
        #   package = pkgs.lacy;
        # };

        home.packages = [ pkgs.lacy ];
        programs.zsh.initContent = ''
          eval "$(${pkgs.lacy} init zsh --custom-fuzzy ${pkgs.fzf})"
        '';
      };

    nixpkgs = {
      params.overlays = [
        inputs.lacy.overlays.default
      ];
    };
  };
}
