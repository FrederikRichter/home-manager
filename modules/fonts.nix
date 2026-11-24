{ pkgs, lib, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = lib.mkAfter [
        "Sarasa UI SC"
        "Sarasa UI TC"
      ];
      monospace = lib.mkAfter [
        "Sarasa Mono SC"
        "Sarasa Mono TC"
        "Symbols Nerd Font Mono"
      ];
    };
  };

  home.packages = with pkgs; [
    cm_unicode
    gyre-fonts
    libertinus
    nerd-fonts.symbols-only
  ];
}
