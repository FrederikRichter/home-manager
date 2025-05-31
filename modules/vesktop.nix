{pkgs, ...}:
{
    programs.vesktop = {
        enable = true;
        settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
            disableMinSize = true;
            clickTrayToShowHide = true;
            minimizeToTray = true;
            discordBranch = "stable";
        };
        vencord.settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
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
