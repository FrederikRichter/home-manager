{ config, pkgs, lib, ... }:

{
    home.packages = [pkgs.keepassxc];
    systemd.user.services.keepassxc = {
        Unit = {
            Description = "keepassxc secret service";
            After = [ "graphical-session-pre.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };

}
