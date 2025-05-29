{config, lib, pkgs, ...}:
{
    accounts.email.accounts = {
        mailbox = {
            address = "frederik.richter@mailbox.org";
            maildir.path = "mailbox";
            realName = "Frederik Richter";
            primary = true;
            userName = "frederik.richter@mailbox.org";
            imap.host = "imap.mailbox.org";
            smtp.host = "smtp.mailbox.org";
            passwordCommand = "$HOME/.nix-profile/bin/secret-tool lookup Title 'Mailbox konto'";
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
