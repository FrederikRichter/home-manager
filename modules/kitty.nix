{ config, pkgs, lib, ... }:

{
  programs.kitty = {
  enable = true;
  extraConfig = ''
    shell zsh
    confirm_os_window_close 0
    startup_session launch.conf
    window_padding_width 10
    font_size        14.0
  '';
  };
}
