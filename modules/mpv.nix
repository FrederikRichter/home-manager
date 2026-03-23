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
                interpolation-threshold="0.01";
                tscale="sphinx";
                tscale-blur="0.65";
                target-colorspace-hint="yes";
                target-colorspace-hint-mode="target";
                gpu-api="vulkan";
                gpu-context="waylandvk";
                target-peak=1000;
                target-prim="display-p3";
                target-trc="pq";
                hdr-compute-peak="yes";
                deband="yes";
                inverse-tone-mapping="yes";
                save-position-on-quit="yes";
                gamut-mapping-mode="perceptual";
            };
        };
}
