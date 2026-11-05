_:
let
  isHdr = ''(p["video-params/gamma"] == "pq" or p["video-params/gamma"] == "hlg")'';
  isTv = ''(p["display-names"] and table.concat(p["display-names"], ","):find("HDMI%-A%-1") ~= nil)'';

  mkHdrProfile = { cond, peak }: {
    profile-cond = "${isHdr} and ${cond}";
    profile-restore = "copy";
    target-peak = peak;
    target-prim = "display-p3";
    target-trc = "pq";
  };
in
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
      hdr = mkHdrProfile {
        cond = "not ${isTv}";
        peak = "1000";
      };

      hdr-tv = mkHdrProfile {
        cond = isTv;
        peak = "387";
      };
    };
  };
}

