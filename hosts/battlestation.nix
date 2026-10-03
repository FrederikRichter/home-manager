{ pkgs, lib, ... }:
let 
    xiaomi = {
        output = "DP-1";
        mode = "highres";
        position = "auto";
        scale = 1;
        bitdepth = 10;
        cm = "hdr";
        vrr = 1;
        brightness = 1.0;
        sdrsaturation = 1.0;
        sdr_min_luminance = 0.02;
        sdr_max_luminance = 400;
        max_luminance = 1000;
    };
    tv = {
        output = "HDMI-A-1";
        mode = "4096x2160@60.00Hz";
        position = "auto";
        scale = 2;
        bitdepth = 10;
        cm = "hdr";
        vrr = 1;
        brightness = 1.0;
        sdrsaturation = 1.0;
        sdr_min_luminance = 0.045;
        sdr_max_luminance = 250;
        min_luminance = 0.045;
        max_luminance = 387;
    };
in
    {
    targets.genericLinux.enable = lib.mkForce false;

    hyprland.enable = true;

    wayland.windowManager.hyprland = {
        settings = {
            config.input.kb_layout = "us";

            # Environment variables
            env = [
                { _args = [ "LIBVA_DRIVER_NAME" "nvidia" ]; }
                { _args = [ "__GLX_VENDOR_LIBRARY_NAME" "nvidia" ]; }
                { _args = [ "NVD_BACKEND" "direct" ]; }
            ];
            monitor = [
                xiaomi
                tv
            ];
        };
    };

    # MPV
    programs.mpv.config = {
        profile = "high-quality";
        hwdec="nvdec";
        gpu-api="vulkan";
        gpu-context="waylandvk";
    };


    home.packages = with pkgs; [
        r2modman
        xournalpp
        modded-evolve
    ];

    home.sessionVariables = {
    };

    home.stateVersion = "24.05";
}
