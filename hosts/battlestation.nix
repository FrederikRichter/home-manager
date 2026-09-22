{pkgs, lib, inputs, ...}:
{
targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings = {
        input.kb_layout = "us";
# Environment variables
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
        ];

    };

    # SDR -> HDR mapping. `sdr_max_luminance = 203` anchors SDR graphics white
    # to the BT.2408 recommended 203 nits (previously 80 nits, further boosted
    # by a 1.5x sdrbrightness multiplier). `max_luminance = 1000` is the panel's
    # true HDR peak. monitorv2 options are only read at config load / reload,
    # not via `hyprctl keyword`, and a monitorv2 rule fully defines the output.
    extraConfig = ''
        monitorv2 {
            output =
            mode = highres
            position = auto
            scale = 1
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
    profile = "high-quality";
    vo="gpu-next";
    hwdec="nvdec";
    gpu-api="vulkan";
    gpu-context="waylandvk";
};


home.packages = with pkgs ;[
    r2modman
    xournalpp
] ++ [inputs.evolved.packages.${pkgs.stdenv.hostPlatform.system}.default];

home.sessionVariables = {
};

home.stateVersion = "24.05";
}
