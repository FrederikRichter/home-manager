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
      "inode/directory" = "nautilus.desktop";
    };

    associations.added = {
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
      "application/pdf" = [ "zathura.desktop" ];
      "document/pdf" = [ "zathura.desktop" ];
      "inode/directory" = [ "nautilus.desktop" ];
    };
  };
};
}
