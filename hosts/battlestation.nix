{pkgs, lib, inputs, ...}:
{
shikane.enable = true;

targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings = {
        input.kb_layout = "us";
        monitor = [
            ", highres,auto,1,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.5, sdrsaturation, 1.2"
        ];
# Environment variables
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
        ];

    };
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
