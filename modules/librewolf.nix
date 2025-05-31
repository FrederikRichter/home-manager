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
    home.file."/.librewolf/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
    {
        "allowed_extensions": [
            "keepassxc-browser@keepassxc.org"
        ],
        "description": "KeePassXC integration with native messaging support",
        "name": "org.keepassxc.keepassxc_browser",
        "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
        "type": "stdio"
    }
    '';
}
