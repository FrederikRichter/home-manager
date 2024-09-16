{ config, pkgs, lib, ... }:

{
    programs.mbsync.enable = true;
    services.mbsync = {
      # systemd service
      enable = true;
      postExec = ''
        ${pkgs.notmuch}/bin/notmuch new
      '';
    };

    programs.msmtp = {
      enable = true;
    };

    programs.notmuch = {
        enable = true;
        new = {
            tags = ["inbox" "unread"];
        };
        hooks = {
            postNew = ''
                notmuch tag +shopping -- tag:inbox and to:frederik.shopping@mailbox.org
                notmuch tag +scammy -- tag:inbox and to:fredster@mailbox.org
                notmuch tag +gaming -- tag:inbox and to:frederik.gaming@mailbox.org
                notmuch tag +main -- tag:inbox and to:frederik.richter@mailbox.org
                '';
        };
    };

    home.file.aercNmQueries = {
      target = "${config.xdg.configHome}/aerc/nm-qmap";
      text = ''
        INBOX = tag:inbox and not tag:archived
        unread = tag:unread
        main = tag:main
        scammy = tag:scammy
        shopping = tag:shopping
      '';
    };

    programs.aerc = {
        enable = true;
        extraConfig = {
            general.unsafe-accounts-conf = true;
            filters = {
                "text/plain" = "colorize";
                "text/calendar" = "calendar";
                "message/delivery-status" = "colorize";
                "message/rfc822" = "colorize";
                "text/html" = "${pkgs.w3m}/bin/w3m -T text/html -cols $(tput cols) -dump -o display_image=false -o display_link_number=true";
            };
            openers = {
                "application/pdf" = "${pkgs.zathura}/bin/zathura";
            };
        };
    };

    accounts.email.accounts.mailbox = {
        address = "frederik.richter@mailbox.org";
        maildir.path = "mailbox";
        realName = "Frederik Richter";
        primary = true;
        aerc.enable = true;
        notmuch.enable = true;
        msmtp.enable = true;
        mbsync = {
            enable = true;
            create = "both";
            extraConfig.account = {
                PipelineDepth = 20;
                timeout = 3600;
            };
        };

        userName = "frederik.richter@mailbox.org";
        imap.host = "imap.mailbox.org";
        smtp.host = "smtp.mailbox.org";
        passwordCommand = "$HOME/.nix-profile/bin/secret-tool lookup Title 'Mailbox konto'";
        aliases = [
            "fredster@mailbox.org"
            "frederik.shopping@mailbox.org"
            "frederik.gaming@mailbox.org"
        ];
    };

}
