{pkgs}:
{
    programs.vesktop = {
        enable = true;
        vencord.settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
            disableMinSize = true;
            plugins = {
                MessageLogger.enabled = true;
                FakeNitro.enabled = true;
            };
        };
    };


    systemd.user.services.vesktop = {
        Unit = {
            Description = "vesktop autostart";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.vesktop}/bin/vesktop";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
