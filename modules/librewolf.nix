{ config, pkgs, lib, ... }:
{
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
