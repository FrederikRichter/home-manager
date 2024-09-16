{ config, pkgs, lib, ... }:
{
    home.packages = [ pkgs.xdg-desktop-portal-gtk ];
    gtk = lib.mkDefault {
        enable = true;
        theme = {
            name = "Gruvbox Dark Theme";
            package = pkgs.gruvbox-dark-gtk;
        };
        iconTheme = {
            name = "Gruvbox Dark Icons";
            package = pkgs.gruvbox-dark-icons-gtk;
        };
    };
}
