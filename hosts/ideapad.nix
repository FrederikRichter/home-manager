{config, pkgs, lib, inputs, ...}:
{
shikane.enable = true;

targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings = {
        monitor = [
            ", highres,auto,2,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.5, sdrsaturation, 1.2"
        ];
    };
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
