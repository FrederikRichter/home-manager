{ config, pkgs, libs, ... }:
{
    stylix = {
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        image = pkgs.fetchurl {
            url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-dracula.png?raw=true";
            sha256 = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
        };
        fonts = {
            monospace = {
                package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
                name = "JetBrainsMono Nerd Font Mono";
            };
        };
    };
}
