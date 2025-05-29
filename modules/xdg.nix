{config, lib, pkgs, ...}:
{
    xdg = {
        enable = true;
        mime.enable = true;
        userDirs.enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "x-scheme-handler/http" = "qutebrowser.desktop";
                "x-scheme-handler/https" = "qutebrowser.desktop";
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
      home.file."Desktop".source = null;
      home.file."Downloads".source = null;
      home.file."Videos".source = null;
      home.file."Documents".source = null;
      home.file."Music".source = null;
      home.file."Pictures".source = null;
      home.file."git".source = null;
}
