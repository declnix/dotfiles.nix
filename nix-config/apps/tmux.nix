{ ... }:
{
  nix-config.apps.tmux = {
    home =
      { pkgs, ... }@inputs:
      {
        programs.tmux = {
          plugins = with pkgs.tmuxPlugins; [ battery ];

          extraConfig = ''
            # ==> configs
            setw -g mouse on
            setw -g mode-keys vi
            set -g status on
            set -g base-index 1
            set -g pane-base-index 1
            set -g renumber-windows on
            set -g status-left-style 'fg=white'
            set -g message-style 'fg=white bg=black bold'

            # statusbar
            set -g status-position bottom
            set -g status-justify left
            set -g status-style 'fg=white'
            set -g status-left '#[fg=orange bold] #S #[fg=white]:: '
            set -g status-right '#[fg=gray bold] #(cat /sys/class/power_supply/BAT1/capacity)%% #[fg=white]:: #[fg=white bold]  %H:%M'
            set -g status-right-length 50
            set -g status-left-length 50
            setw -g window-status-current-style 'fg=red  bold'
            setw -g window-status-current-format '#W\#I'
            setw -g window-status-style 'fg=colour241 bold'
            setw -g window-status-format '#W\#I'
            setw -g window-status-bell-style 'fg=colour2 bg=white bold'

            # custom keybindings
            bind -T root M-w choose-tree 

            set-option -g default-shell ${pkgs.zsh}/bin/zsh
          '';

          terminal = "tmux-256color";
          historyLimit = 100000;

          enable = true;
        };
      };

    tags = [
      "@mux"
      "default"
    ];
  };
}
