{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.cm_unicode ];
}
