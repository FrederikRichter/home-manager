{ lib, pkgs, config, options, ... }:
{
    programs.mpv = {
            enable = true;
            config = {
                hwdec="no";
                ytdl-format = "bestvideo+bestaudio";
                gpu-context="wayland";
            };
        };
}
