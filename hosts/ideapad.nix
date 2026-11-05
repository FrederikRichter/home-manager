{ lib, ... }:

let
  internalMonitor = {
    output = "eDP-1";
    mode = "highres";
    position = "auto";
    scale = 2;
    bitdepth = 10;
    cm = "hdr";
    vrr = 1;
    brightness = 1.0;
    sdrsaturation = 1.0;
    sdr_min_luminance = 0.02;
    sdr_max_luminance = 400;
    max_luminance = 1000;
  };

  hdmi = {
    output = "HDMI-A-1";
    mode = "preferred";
    position = "auto-left";
  };
in
{
  hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      internalMonitor
      hdmi
    ];

    workspace_rule = [
      {
        workspace = "5";
        monitor = "HDMI-A-1";
        default = true;
      }
      {
        workspace = "1";
        monitor = "eDP-1";
      }
      {
        workspace = "2";
        monitor = "eDP-1";
      }
      {
        workspace = "3";
        monitor = "eDP-1";
      }
      {
        workspace = "4";
        monitor = "eDP-1";
        default = true;
      }
    ];
  };

  programs.mpv.config.hwdec = "vulkan";
  programs.foot.settings.main.font = lib.mkForce "monospace:size=12";
}
