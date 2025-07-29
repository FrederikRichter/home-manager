{ lib, pkgs, config, options, ... }:
{
    programs.mpv = {
            enable = true;
            config = {
                profile = "high-quality";
                vo="gpu-next";
                hwdec="nvdec";
                video-sync="display-resample";
                interpolation="yes";
                tscale="sphinx";
                tscale-blur="0.65";
                target-colorspace-hint="yes";
                gpu-api="vulkan";
                gpu-context="waylandvk";
                target-peak=1000;
                target-prim="bt.2020";
                target-trc="pq";
                deband="no";
                vf="format:film-grain=no";
                save-position-on-quit="yes";
            };
        };
}
