{ pkgs, lib, ... }:

let
  # KeePassXC exposes its database as the default Secret Service collection.
  # Wait until that collection is unlocked before starting Mailspring, otherwise
  # Mailspring 1.26+ fails with "Password Management Error" / "encryption is not
  # available".
  startMailspring = pkgs.writeShellScript "start-mailspring" ''
    set -u
    export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.systemd ]}:$PATH

    # Wait for KeePassXC to publish org.freedesktop.secrets.
    for _ in $(seq 1 30); do
      if busctl --user status org.freedesktop.secrets >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    # Wait for the default collection to be unlocked. The collection is not
    # hardcoded here: KeePassXC names it after the database, so use the
    # "default" alias instead.
    echo "Waiting for the KeePassXC default collection to be unlocked..." >&2
    locked=""
    for _ in $(seq 1 300); do
      locked="$(busctl --user get-property \
        org.freedesktop.secrets \
        /org/freedesktop/secrets/aliases/default \
        org.freedesktop.Secret.Collection Locked 2>/dev/null || true)"
      if [ "$locked" = "b false" ]; then
        break
      fi
      sleep 1
    done

    if [ "$locked" != "b false" ]; then
      echo "KeePassXC is still locked;" >&2
      exit
    fi

    # On Hyprland the sync fallback would otherwise use basic_text instead of
    # KeePassXC's Secret Service.
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

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Shadow the desktop file shipped by the Mailspring package so that manual
  # launches also get the KeePassXC password-store flag.  Using xdg.dataFile
  # instead of xdg.desktopEntries avoids the makeDesktopItem/extraConfig
  # incompatibility between this nixpkgs and home-manager revision.
  xdg.dataFile."applications/Mailspring.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Mailspring
    GenericName=Mail Client
    Comment=A beautiful, modern email client
    Exec=${pkgs.mailspring}/bin/mailspring --password-store=gnome-libsecret %U
    Icon=mailspring
    Terminal=false
    Categories=Network;Email;
    MimeType=x-scheme-handler/mailto;x-scheme-handler/mailspring;
  '';
}
