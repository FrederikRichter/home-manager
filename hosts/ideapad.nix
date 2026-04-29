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
    settings.bind = [
            # Screenshot
            ", XF86Cut, exec, grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png"
    ];
};

wayland.windowManager.hyprland = {
    settings = {
        input.kb_layout = "us";
        monitor = [
            ", highres,auto,2,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.5, sdrsaturation, 1.2"
            # ", highres,auto,1,bitdepth,10,vrr,1"
        ];
        # gesture = ["3, horizontal, workspace"];
        env = [
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
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

home.packages = with pkgs ;[
    r2modman
    qbittorrent
    rustdesk
    xournalpp
];

home.sessionVariables = {
};

home.stateVersion = "25.11";
}
