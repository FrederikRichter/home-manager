{ config, pkgs, lib,  ... }:
{
    stylix = {
        enable = true;
	targets = {
		vesktop.enable = false;
		nixvim.enable = false;
	};
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml";
        image = ../wallpaper/gruvbox_light_linux.png;
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
    };
}
