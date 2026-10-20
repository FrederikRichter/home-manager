{ config, pkgs, lib, ... }:

{
    programs.foot = {
        enable = true;
        settings = {
            main = {
                shell = "zsh";
                pad = "10x10";
            };
            bell = {
                notify = "no";
            };
        };
    };
}
