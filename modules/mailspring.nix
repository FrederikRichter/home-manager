{ pkgs, lib, ... }:

let
  # Wait for KeePassXC's default Secret Service collection to unlock.
  startMailspring = pkgs.writeShellScript "start-mailspring" ''
    set -u
    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.procps pkgs.systemd ]}:$PATH

    # Do not start a second instance when systemd restarts this unit.
    if pgrep -u "$(id -u)" -f -- "${pkgs.mailspring}/share/mailspring/resources/app\.asar( |$)" >/dev/null 2>&1; then
      exit 0
    fi

    for _ in $(seq 1 30); do
      busctl --user status org.freedesktop.secrets >/dev/null 2>&1 && break
      sleep 1
    done

    locked=""
    for _ in $(seq 1 300); do
      locked="$(busctl --user get-property \
        org.freedesktop.secrets \
        /org/freedesktop/secrets/aliases/default \
        org.freedesktop.Secret.Collection Locked 2>/dev/null || true)"
      [ "$locked" = "b false" ] && break
      sleep 1
    done

    [ "$locked" = "b false" ] || exit 0

    exec ${pkgs.mailspring}/bin/mailspring \
      --background \
      --password-store=gnome-libsecret \
      "$@"
  '';
in
{
  home.packages = [ pkgs.mailspring ];

  systemd.user.services.mailspring = {
    Unit = {
      Description = "Mailspring mail client";
      After = [ "graphical-session.target" "keepassxc.service" ];
      PartOf = [ "graphical-session.target" ];
      Wants = [ "keepassxc.service" ];
    };

    Service = {
      ExecStart = "${startMailspring}";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.desktopEntries.Mailspring = {
    name = "Mailspring";
    genericName = "Mail Client";
    comment = "A beautiful, modern email client";
    exec = "${pkgs.mailspring}/bin/mailspring --password-store=gnome-libsecret %U";
    icon = "mailspring";
    categories = [ "Network" "Email" ];
    mimeType = [ "x-scheme-handler/mailto" "x-scheme-handler/mailspring" ];
  };
}
