{pkgs, ...}:
{
home.packages = [pkgs.easyeffects];
systemd.user.services.easyeffects = {
    Unit = {
        Description = "Easyeffects service";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
    };

    Service = {
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
        Restart = "on-failure";
    };

    Install = {
        WantedBy = [ "graphical-session.target" ];
    };
};
}
