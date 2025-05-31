{pkgs, ...}:
{
    xdg.desktopEntries.mailspring = {
      name = "Mailspring";
      exec = "${pkgs.mailspring}/bin/mailspring --password-store=gnome-libsecret";
      icon = "mailspring";
      terminal = false;
      comment = "A beautiful, modern email client";
      categories = [ "Network" "Email" ];
    };
}
