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
