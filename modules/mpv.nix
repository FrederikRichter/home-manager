{ lib, pkgs, config, options, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      save-position-on-quit = "yes";
      wayland-internal-vsync = "no";
      ao="alsa";
      target-colorspace-hint-mode= "source";
      target-colorspace-hint = "auto";
    };

    profiles = {
      hdr = {
        profile-cond = "p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\"";
        target-peak = "1000";
        target-prim = "display-p3";
        target-trc = "pq";
        hdr-compute-peak = "yes";
        vo="gpu-next";
      };
    };
  };
}
