{ config, pkgs, libs, ... }:
{
    home.packages = [pkgs.megacmd];
    systemd.user.services.mega = {
        Unit = {
            Description = "mega-cmd server";
            After = [ "network.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.megacmd}/bin/mega-cmd-server";
            Restart = "always";
            Environment = "PATH=${pkgs.megacmd}/bin/";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
