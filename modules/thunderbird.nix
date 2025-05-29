{config, lib, pkgs, ...}:
{
    accounts.email.accounts = {
        mailbox = {
            address = "frederik.richter@mailbox.org";
            maildir.path = "mailbox";
            realName = "Frederik Richter";
            primary = true;
            userName = "frederik.richter@mailbox.org";
            imap = {
                host = "imap.mailbox.org";
                port = 993;
            };
            smtp = {
                host = "smtp.mailbox.org";
                port = 465;
            };
            aliases = [
                "fredster@mailbox.org"
                "frederik.shopping@mailbox.org"
                "frederik.gaming@mailbox.org"
            ];
            thunderbird.enable = true;
        };
    };
    programs.thunderbird = {
        enable = true;
        profiles = {
            "default" = {
                isDefault = true;
            };
        };
    };
}
