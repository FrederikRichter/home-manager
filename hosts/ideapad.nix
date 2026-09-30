{ config, pkgs, lib, ... }:
{
targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings.monitor = [{
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
    }
    {
        output = "HDMI-A-1";
        mode = "4096x2160@59.94Hz ";
        position = "auto";
        scale = 2;
        bitdepth = 10;
        cm = "hdr";
        vrr = 0;
        brightness = 1.0;
        sdrsaturation = 1.0;
        sdr_min_luminance = 0.02;
        sdr_max_luminance = 400;
        max_luminance = 1000;
    }];
};


# MPV
programs.mpv.config = {
    hwdec="vulkan";
    gpu-api="vulkan";
    gpu-context="waylandvk";
    profile="high-quality";
};

home.stateVersion = "25.11";
}
