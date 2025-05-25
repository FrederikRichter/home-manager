{ config, pkgs, lib,  ... }:
{
    stylix = {
        enable = true;
	targets.nixvim.enable = lib.mkForce false;
	targets.neovim.enable = lib.mkForce false;
	targets.vim.enable = lib.mkForce false;

        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml";
        image = pkgs.fetchurl {
            url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-dracula.png?raw=true";
            sha256 = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
        };
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
