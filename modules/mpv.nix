{ lib, pkgs, config, options, ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      save-position-on-quit = "yes";
      wayland-internal-vsync = "no";
    };

    profiles = {
      hdr = {
        profile-cond = "p[\"video-params/primaries\"] == \"bt.2020\" or p[\"video-params/gamma\"] == \"pq\"";

        target-peak = "1000";
        target-colorspace-hint = "yes";
        target-prim = "display-p3";
        target-trc = "pq";
        hdr-compute-peak = "yes";
      };
    };
  };
}
