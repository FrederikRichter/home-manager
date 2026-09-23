{ lib, pkgs, config, options, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      save-position-on-quit = "yes";
      wayland-internal-vsync = "no";
      ao="alsa";
    };

    profiles = {
      hdr = {
        profile-cond = "p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\"";
        target-peak = "1000";
        target-colorspace-hint = "no";
        target-prim = "display-p3";
        target-trc = "pq";
        hdr-compute-peak = "yes";
        profile-restore = "copy-equal";
        vo="gpu-next";
      };
    };
  };
}
