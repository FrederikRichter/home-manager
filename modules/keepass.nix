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
    home.file = {
        "${config.xdg.configHome}/keepassxc/keepassxc.ini" = {
            text = ''
                [General]
                ConfigVersion=2

                [Browser]
                CustomProxyLocation=

                [FdoSecrets]
                ConfirmAccessItem=false
                Enabled=true
                ShowNotification=true

                [GUI]
                MinimizeOnStartup=true
                TrayIconAppearance=monochrome-light

                [PasswordGenerator]
                AdditionalChars=
                ExcludedChars=

                [Security]
                LockDatabaseScreenLock=false
                    '';
        };
    };

}
