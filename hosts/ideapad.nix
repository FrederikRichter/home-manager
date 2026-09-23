{config, pkgs, lib, inputs, ...}:
{
targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings.monitor = {
        output = "eDP-1";
        mode = "highres";
        position = "auto";
        scale = 2;
        bitdepth = 10;
        cm = "hdr";
        vrr = 1;
        sdrbrightness = 1.0;
        sdrsaturation = 1.0;
        sdr_min_luminance = 0.02;
        sdr_max_luminance = 400;
        max_luminance = 1000;
    };
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
