{ config, pkgs, ... }:

{
  programs.kitty = {
  enable = true;
  extraConfig = ''
    shell zsh
    confirm_os_window_close 0
  '';
  };
}
