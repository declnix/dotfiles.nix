# @skip
{
  imports = [
    # @macro :: grep -rl '@nix-config-modules' . | xargs grep -L '@skip' | sort
    ./apps/ags.nix
    ./apps/alacritty.nix
    ./apps/albert.nix
    ./apps/devbox.nix
    ./apps/direnv.nix
    ./apps/distrobox.nix
    ./apps/eza.nix
    ./apps/fd.nix
    ./apps/fonts.nix
    ./apps/fzf.nix
    ./apps/gh.nix
    ./apps/git.nix
    ./apps/host.nix
    ./apps/kde.nix
    ./apps/lacy.nix
    ./apps/niri.nix
    ./apps/nix-index.nix
    ./apps/nzf.nix
    ./apps/podman.nix
    ./apps/proxy.nix
    ./apps/ripgrep.nix
    ./apps/sudo.nix
    ./apps/tmux.nix
    ./apps/vscode-server.nix
    ./apps/wsl.nix
    ./apps/zoxide.nix
    ./hosts/bl4ck0ut/default.nix
    ./hosts/d34dsh1p/default.nix
    ./hosts/l4p0stv01d/default.nix
    # @end
  ];
}
