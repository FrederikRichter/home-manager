{config, pkgs, lib, ...}:
{
shikane.enable = true;



wayland.windowManager.hyprland = {
    settings = {
        monitor = [
            "DP-4,preferred,auto,1,bitdepth,10,vrr,1,cm,hdr,sdrbrightness, 1.3, sdrsaturation, 1.15"
        ];
        experimental = {
            xx_color_management_v4 = true;
        };

# Environment variables
        env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];

    };
};

home.packages = with pkgs ;[
    r2modman
    qbittorrent
    brave
];


	home.sessionVariables = {
        ENABLE_HDR_WSI=1;
	};
}
