{config, pkgs, lib, ...}:
{
shikane.enable = true;

targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

programs.waybar = {
    systemd.target = "hyprland-session.target";
    settings.mainBar = {
        modules-left = [ "hyprland/workspaces" "idle_inhibitor" ];
        modules-right = ["pulseaudio" "network" "battery" "cpu" "memory" "disk" "clock" "bluetooth" "tray"];
    };
};

wayland.windowManager.hyprland = {
    settings = {
        input.kb_layout = "us";
        monitor = [
            # ", highres,auto,1,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.5, sdrsaturation, 1.2"
            ", highres,auto,1,bitdepth,10,vrr,1"
        ];
        bind = [
            # Screenshot
            ", Print, exec, grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png"
        ];
# Environment variables
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
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
    qbittorrent
    rustdesk
    xournalpp
];

home.sessionVariables = {
};

home.stateVersion = "24.05";
}
