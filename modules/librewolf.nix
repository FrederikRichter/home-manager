{ config, pkgs, lib, ... }:
{
    programs.librewolf = {
        enable = true;
        settings = {
            "browser.sessionstore.resume_from_crash" = false;
            "browser.search.searchEnginesURL" = "https://search.hbubli.cc/";
            "browser.policies.runOncePerModification.setDefaultSearchEngine" =  "https://search.hbubli.cc/";
            "browser.search.separatePrivateDefault" = false;
            "browser.toolbars.bookmarks.visibility" = "never";
        };
    };
}
