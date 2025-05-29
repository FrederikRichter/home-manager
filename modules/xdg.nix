{config, lib, pkgs, username, ...}:
{
    xdg = {
        enable = true;
        mime.enable = true;
        userDirs.enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "x-scheme-handler/http" = "librewolf.desktop";
                "x-scheme-handler/https" = "librewolf.desktop";
                "text/html" = "librewolf.desktop";
                "text/plain" = "nvim.desktop";
                "application/pdf" = "zathura.desktop";
                "document/pdf" = "zathura.desktop";
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
