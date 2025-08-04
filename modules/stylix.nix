{config, pkgs, lib,  ...}:
{
    stylix = {
        enable = true;
        targets = {
            vesktop.enable = false;
            nixvim.enable = false;
            librewolf.profileNames = [ "default" ];
        };
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml";
        fonts = {
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
        iconTheme = {
            enable = true;
            package = pkgs.whitesur-icon-theme;
            light = "WhiteSur";
        };
    };
}
