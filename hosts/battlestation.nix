{pkgs, lib, inputs, ...}:
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

        monitor = {
            output = "";
            mode = "highres";
            position = "auto";
            scale = 1;
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
] ++ [ (inputs.evolved.lib.mkModdedEvolve pkgs) ];

home.sessionVariables = {
};

home.stateVersion = "24.05";
}
