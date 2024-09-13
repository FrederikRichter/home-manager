{ config, pkgs, lib, ... }:

{
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
        passwordCommand = "keepassxc-cli show Mega/Database.kdbx 'Mailbox konto' -a 'Password'"
    };
}
