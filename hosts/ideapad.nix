{config, pkgs, lib, inputs, ...}:
{
targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    # SDR -> HDR mapping for the internal 1000-nit panel. Same as battlestation
    # except the output (internal eDP-1 instead of the fallback) and the scale.
    extraConfig = ''
        monitorv2 {
            output = eDP-1
            mode = highres
            position = auto
            scale = 2
            bitdepth = 10
            cm = hdr
            vrr = 1
            sdrbrightness = 1.0
            sdrsaturation = 1.0
            sdr_min_luminance = 0.2
            sdr_max_luminance = 400
            max_luminance = 1000
        }
    '';
};


# MPV
programs.mpv.config = {
    vo="gpu-next";
    hwdec="vulkan";
    gpu-api="vulkan";
    gpu-context="waylandvk";
    profile="high-quality";
};

# home.packages = [inputs.evolved.packages.${pkgs.stdenv.hostPlatform.system}.default];


home.stateVersion = "25.11";
}
