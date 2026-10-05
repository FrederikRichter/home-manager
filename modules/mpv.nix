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
            hdr-compute-peak = "yes";
            vo = "gpu-next";
            profile = "high-quality";
            gpu-api="vulkan";
            gpu-context="waylandvk";
        };

        profiles = {
            hdr = {
                profile-cond = "(p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\") and not (p[\"display-names\"] and table.concat(p[\"display-names\"], \",\"):find(\"HDMI%-A%-1\"))";
                target-peak = "1000";
                target-prim = "display-p3";
                target-trc = "pq";
            };

            hdr-tv = {
                profile-cond = "(p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\") and (p[\"display-names\"] and table.concat(p[\"display-names\"], \",\"):find(\"HDMI%-A%-1\") ~= nil)";
                target-peak = "387";
                target-prim = "display-p3";
                target-trc = "pq";
            };
        };
    };
}
