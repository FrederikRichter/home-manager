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
        tu-bs = {
            address = "frederik.richter@tu-braunschweig.de";
            maildir.path = "tubs";
            realName = "Frederik Richter";
            userName = "AD\\y0117852";
            imap = {
                host = "mail.tu-braunschweig.de";
                port = 993;
            };
            smtp = {
                host = "mail.tu-braunschweig.de";
                port = 587;
                tls.useStartTls = true;
            };
            thunderbird.enable = true;
            };

        gmail = {
            address = "frederik.richter@tu-braunschweig.de";
            maildir.path = "tubs";
            realName = "Frederik Richter";
            userName = "frederik.twix@gmail.com";
            imap = {
                host = "imap.gmail.com";
                port = 993;
            };
            smtp = {
                host = "smtp.gmail.com";
                port = 465;
            };
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
