{config, lib, pkgs, ...}:
{
    xdg = {
        enable = true;
        mime.enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "x-scheme-handler/http" = ["qutebrowser.desktop"];
                "x-scheme-handler/https" = ["qutebrowser.desktop"];
                "text/html" = ["qutebrowser.desktop"];
                "text/plain" = ["nvim.desktop"];
                "application/pdf" = ["zathura.desktop"];
            };
        };
        desktopEntries = {
            nvim = {
                name = "neovim from flake";
                genericName = "text editor";
                exec = "${pkgs.kitty}/bin/kitty -e nvim %U";
                terminal = true;
                categories = [  ];
                mimeType = [ "text/plain" ];
            };
            qutebrowser = {
                name = "qutebrowser";
                genericName = "webbrowser";
                exec = "${pkgs.qutebrowser}/bin/qutebrowser %U";
                terminal = false;
                categories = [  ];
                mimeType = [ "text/html" "text/xml"];
            };
            zathura = {
                name = "zathura";
                genericName = "pdf viewer";
                exec = "${pkgs.zathura}/bin/zathura %U";
                terminal = false;
                categories = [  ];
                mimeType = [ "application/pdf" ];
            };
        };
    };
}
