{config, lib, pkgs, ...}:
{
    desktopEntries.rquickshare = {
      name = "quickshare (patched)";
      exec = "sh -c \"__NV_DISABLE_EXPLICIT_SYNC=1 ${pkgs.rquickshare}/bin/rquickshare\"";
      icon = "rquickshare";
      terminal = false;
      comment = "quickshare for linux";
      categories = [ "Network" ];
    };

    systemd.user.services.mailspring = {
        Unit = {
            Description = "quickshare autostart";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
            Requires = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "sh -c \"__NV_DISABLE_EXPLICIT_SYNC=1 ${pkgs.rquickshare}/bin/rquickshare\"";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
