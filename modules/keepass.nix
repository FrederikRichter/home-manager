{ pkgs, ... }:
{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser = {
        Enabled = true;
        UseCustomBrowser = true;
        CustomBrowserType = 2;
      };
      GUI.CheckForUpdates = false;
      Security.ClearClipboardTimeout = 20;
      FdoSecrets.Enabled = true;
    };
  };

  # KeePassXC must run before Mailspring needs the Secret Service.
  systemd.user.services.keepassxc = {
    Unit = {
      Description = "KeePassXC secret service";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
