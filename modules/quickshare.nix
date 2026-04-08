{config, lib, pkgs, ...}:
{
    # systemd.user.services.rquickshare = {
    #     Unit = {
    #         Description = "quickshare autostart";
    #         After = [ "graphical-session.target" ];
    #         PartOf = [ "graphical-session.target" ];
    #         Requires = [ "graphical-session.target" ];
    #     };
    #
    #     Service = {
    #         # Environment = "WEBKIT_DISABLE_COMPOSITING_MODE=1"; # HOTFIX
    #         ExecStart = "${pkgs.rquickshare}/bin/rquickshare";
    #         Restart = "on-failure";
    #     };
    #
    #     Install = {
    #         WantedBy = [ "graphical-session.target" ];
    #     };
    # };
}
