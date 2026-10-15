{ lib, pkgs, config, options, ... }:
{
programs.mpv = {
  enable = true;

  config = {
    save-position-on-quit = "yes";

    ao = "alsa";

    vo = "gpu-next";
    gpu-api = "vulkan";
    gpu-context = "waylandvk";
    profile = "high-quality";
    demuxer-max-bytes = "1G";


    target-colorspace-hint = "auto";
  };

  profiles = {
    hdr = {
      profile-cond =
        "(p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\")"
        + " and not (p[\"display-names\"] and table.concat(p[\"display-names\"], \",\"):find(\"HDMI%-A%-1\"))";

      profile-restore = "copy";

      target-peak = "1000";
      target-prim = "display-p3";
      target-trc = "pq";
    };

    hdr-tv = {
      profile-cond =
        "(p[\"video-params/gamma\"] == \"pq\" or p[\"video-params/gamma\"] == \"hlg\")"
        + " and (p[\"display-names\"] and table.concat(p[\"display-names\"], \",\"):find(\"HDMI%-A%-1\") ~= nil)";

      profile-restore = "copy";
      target-peak = "387";
      target-prim = "display-p3";
      target-trc = "pq";
    };
  };
};
}
