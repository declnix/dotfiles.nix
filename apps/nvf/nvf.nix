# @nix-config-modules
{ inputs, ... }:
{
  nix-config.apps.nvf = {
    home =
      { pkgs, ... }:
      {
        imports = [
          # /imports :: find . -iname '*.nix' | grep -Ev '(nvf|overlay)\.nix'
          ./plugins/fzf-lua.nix
          ./plugins/fyler.nix
          ./config/ui.nix
          ./config/languages/markdown.nix
          # /imports
        ];

        programs.nvf = {
          settings = {
            vim = {
              viAlias = true;
              vimAlias = true;

              lsp = {
                enable = true;
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
    ];

    nixpkgs = {
      params.overlays = [
        (import ./overlay.nix { inherit inputs; })
      ];
    };
  };

  nix-config.modules.home-manager = [
    inputs.nvf.homeManagerModules.default
  ];
}
