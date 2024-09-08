{ config, pkgs, libs, ... }:
{
    home.packages = [pkgs.megacmd];
    systemd.user.services.mega = {
        Unit = {
            Description = "mega-sync";
            After = [ "graphical-session-pre.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.megacmd}/bin/mega-sync";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
