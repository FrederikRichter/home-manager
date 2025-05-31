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
                Enabled=true

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

                [KeeShare]
                Active="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Active/>\n</KeeShare>\n"
                    Foreign="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <Foreign/>\n</KeeShare>\n"
                    Own="<?xml version=\"1.0\"?>\n<KeeShare xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n  <PrivateKey/>\n  <PublicKey/>\n</KeeShare>\n"
                    QuietSuccess=true

                [Security]
                LockDatabaseScreenLock=false
                ClearClipboardTimeout=40
                '';
        };
    };

}
