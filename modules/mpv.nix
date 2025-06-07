{ lib, pkgs, config, options, ... }:
{
    programs.mpv = {
            enable = true;
            config = {
                profile = "gpu-hq";
                vo="gpu-next";
                hwdec="auto-copy";
                video-sync="display-resample";
                interpolation="yes";
                target-colorspace-hint="yes";
                gpu-context="wayland";
                gpu-api="vulkan";
            };
        };
}
