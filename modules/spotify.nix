{pkgs, lib, config, ... }:
{
    xdg.desktopEntries.spotify = {
      name = "Spotify";
      exec = "${pkgs.spotify}/bin/spotify --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "spotify";
      terminal = false;
      comment = "Spotify music player";
      categories = [ "Audio" "Music" ];
    };
}
