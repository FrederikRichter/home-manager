{ config, pkgs, libs, ... }:
{
    stylix = {
    enable = true;
    image = pkgs.fetchurl {
        url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-dracula.png?raw=true";
        sha256 = "";
    };
    }
}
