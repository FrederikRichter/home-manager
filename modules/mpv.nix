{ lib, pkgs, config, options, ... }:
{
    programs.mpv = {
            enable = true;
            config = {
                profile = "gpu-hq";
                hwdec="auto-safe";
                vo="gpu";
                ytdl-format = "bestvideo+bestaudio";
                cache-default = 4000000;
                gpu-context="wayland";
            };
        };
}
