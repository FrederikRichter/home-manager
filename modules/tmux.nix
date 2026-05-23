{ pkgs, lib, ... }:
let
tmux-nvim = pkgs.tmuxPlugins.mkTmuxPlugin
{
    pluginName = "tmux.nvim";
    version = "latest";
    src = pkgs.fetchFromGitHub {
        owner = "aserowy";
        repo = "tmux.nvim/";
        rev = "32ceaf2793582955ef9576809730878c4d2d9426";
        sha256 =  "sha256-dKarwc0NByKV8/rMHnHqwiRTgeiXAPGsviFBP+bOaXI=";
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
        tmuxPlugins.better-mouse-mode
    ];
        extraConfig = ''
            # custom prefix
            unbind C-b
            set -g prefix C-Space
            bind C-Space send-prefix

            unbind-key '%'
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
