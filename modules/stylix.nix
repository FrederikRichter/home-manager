{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    image = lib.mkDefault ../assets/wallpaper/abstract.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    targets = {
      nixvim.enable = false;
      rofi.enable = false;
      vesktop.enable = false;
    };

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
