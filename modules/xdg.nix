{config, lib, ...}:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
    "x-scheme-handler/http" = ["qutebrowser.desktop"];
    "x-scheme-handler/https" = ["qutebrowser.desktop"];
    "text/html" = ["qutebrowser.desktop"];
    "application/pdf" = ["zathura.desktop"];
    };
  };
}
