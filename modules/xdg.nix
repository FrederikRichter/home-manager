{config, lib, pkgs, ...}:
{
    xdg = {
        enable = true;
        mime.enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "x-scheme-handler/http" = "qutebrowser.desktop";
                "x-scheme-handler/https" = "qutebrowser.desktop";
                "text/html" = "qutebrowser.desktop";
                "text/plain" = "nvim.desktop";
                "application/pdf" = "zathura.desktop";
                "document/pdf" = "zathura.desktop";
            };
            associations.removed = {
                "application/pdf" = "inkscape.desktop";
                "document/pdf" = "inkscape.desktop";
                "x-scheme-handler/https" = "firefox.desktop";
                "x-scheme-handler/http" = "firefox.desktop";
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
        };
    };
}
