{ config, pkgs, lib, ... }:
{
    programs.librewolf = {
        enable = true;
        settings = {
            "browser.sessionstore.resume_from_crash" = false;
        };
    };
}
