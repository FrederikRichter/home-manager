{ lib, pkgs, ... }:

let
  browser = "helium.desktop";
  editor = "nvim.desktop";
  pdfViewer = "org.pwmt.zathura-pdf-mupdf.desktop";
  fileManager = "nemo.desktop";

  browserMimeTypes = [
    "application/xhtml+xml"
    "text/html"
    "text/xml"
    "x-scheme-handler/about"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];

  editorMimeTypes = [
    "text/english"
    "text/plain"
    "text/markdown"
    "text/x-makefile"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "text/x-c"
    "text/x-c++"
    "application/json"
    "application/toml"
    "application/yaml"
    "text/x-nix"
  ];

  defaults = {
    "application/pdf" = pdfViewer;
    "inode/directory" = fileManager;
    "text/markdown" = editor;
    "text/plain" = editor;
    "x-scheme-handler/discord" = "discord.desktop";
    "x-scheme-handler/mailspring" = "Mailspring.desktop";
    "x-scheme-handler/mailto" = "Mailspring.desktop";
    "x-scheme-handler/sgnl" = "signal.desktop";
    "x-scheme-handler/signalcaptcha" = "signal.desktop";
  };
in
{
  xdg = {
    enable = true;

    desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "${pkgs.foot}/bin/foot -e ${pkgs.nixvim}/bin/nvim %F";
      icon = "nvim";
      categories = [ "Utility" "TextEditor" "Development" ];
      mimeType = editorMimeTypes;
      startupNotify = false;
    };

    terminal-exec = {
      enable = true;
      settings.default = [ "foot.desktop" ];
    };

    mimeApps = {
      enable = true;
      defaultApplications = defaults // lib.genAttrs browserMimeTypes (_: browser);
      associations.added = lib.genAttrs editorMimeTypes (_: [ editor ]) // {
        "application/pdf" = [ pdfViewer ];
        "image/svg+xml" = [ pdfViewer ];
        "inode/directory" = [ fileManager ];
      };
    };

    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
  };

  home.sessionVariables.BROWSER = "helium";
}

