{ pkgs, ... }:
let
# example config
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };
tmux-nvim = pkgs.tmuxPlugins.mkTmuxPlugin
{
    pluginName = "tmux.nvim";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
        owner = "aserowy";
        repo = "tmux.nvim/";
        rev = "57220071739c723c3a318e9d529d3e5045f503b8";
        sha256 = "sha256-zpg7XJky7PRa5sC7sPRsU2ZOjj0wcepITLAelPjEkSI=";
    };
};
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 100000;
    plugins = with pkgs;
    [
        tmux-nvim
        tmuxPlugins.sensible
        {
            plugin = tmux-super-fingers;
            extraConfig = "set -g @super-fingers-key f";
        }
        tmuxPlugins.better-mouse-mode
    ];
        extraConfig = ''
            # custom prefix
            unbind C-b
            set -g prefix C-Space
            bind C-Space send-prefix

            unbind-key %
            unbind-key '"'
            bind-key - split-window -h
            bind-key = kill-pane
            bind-key + new-window

            # update sway sock
            set-option -g update-environment "SWAYSOCK"
            set-option -g update-environment "SSH_AUTH_SOCK"

            set -g mode-keys vi
            set -g focus-events on
            setw -g aggressive-resize on
            set -s escape-time 0 #vim mode switching delay
            
            # better copy mode keybinds
            bind-key -n C-b copy-mode
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel


            set-window-option -g automatic-rename on
            set-option -g set-titles on
            '';
  };
}
