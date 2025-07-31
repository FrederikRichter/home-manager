{ config, pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "zsh";
        # (Set the font with family and size, adjust if you want a different font)
        # font = "monospace:size=14";
        pad = "10x10";
      };
      bell = {
        notify = "no";
      };
    };
  };
}
