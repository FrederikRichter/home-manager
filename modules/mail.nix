{ config, pkgs, lib, ... }:

{
    programs.aerc = {
        enable = true;
        extraConfig.general.unsafe-accounts-conf = true;
        };

    accounts.email.accounts.mailbox = {
        address = "frederik.richter@mailbox.org";
        maildir.path = "mailbox";
        realName = "Frederik Richter";
        primary = true;
        mbsync = {
            enable = true;
            create = "both";
        };
        aerc = {
            enable = true;
        };
        userName = "frederik.richter@mailbox.org";
        imap.host = "imap.mailbox.org";
        smtp.host = "smtp.mailbox.org";
        passwordCommand = "~/.config/aerc/wait-for-creds.sh Title 'Mailbox konto'";
    };

    home.file = {
        "${config.xdg.configHome}/.config/aerc/wait-for-creds.sh" = {
            text = ''
                #!/bin/bash

                secret-tool lookup "$1" "$2"
                # wait until the password is available
                while [ $? != 0 ]; do
                    secret-tool lookup "$1" "$2"
                done;
            '';
            executable = true;
        };
    };
}
