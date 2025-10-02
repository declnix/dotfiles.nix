# @skip
{
  imports = [
    # @macro :: find . -iname '*.nix' | xargs grep -L '@skip'  | sort
    ./config/languages/markdown.nix
    ./config/ui.nix
    ./plugins/fyler.nix
    ./plugins/fzf-lua.nix
    # @end
  ];
}
