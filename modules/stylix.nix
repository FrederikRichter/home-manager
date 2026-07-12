{config, pkgs, lib,  ...}:
{
    stylix = {
        enable = true;
        image = ../wallpaper/abstract.jpg;
        targets = {
            vesktop.enable = false;
            nixvim.enable = false;
            librewolf.profileNames = [ "default" ];
        };
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        fonts = {
            sansSerif = {
                package = pkgs.inter;
                name = "Inter";
            };
            monospace = {
                package = pkgs.nerd-fonts.jetbrains-mono;
                name = "JetBrainsMono Nerd Font Mono";
            };
        };
        cursor = {
            name = "macOS";
            package = pkgs.apple-cursor;
            size = 26;
        };
        icons = {
            enable = true;
            package = pkgs.whitesur-icon-theme;
            light = "WhiteSur";
        };
    };
}
