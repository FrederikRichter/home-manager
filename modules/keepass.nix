{ pkgs, ... }:
{
  # KeePassXC writes settings and KeeShare secrets to its config; keep it GUI-managed.
  programs.keepassxc.enable = true;

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
