{ config, lib, ... }:
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar.widgets = {
        concave_edge_corners = false;
        end = [
          "sysmon"
          "notifications"
          "clipboard"
          "volume"
          "battery"
          "network"
          "bluetooth"
          "date"
          "tray"
          "control-center"
        ];
        margin_edge = 10;
        margin_ends = 10;
        position = "bottom";
        scale = 1.15;
      };

      dock.background_opacity = 1.0;

      location.auto_locate = true;

      notification.background_opacity = 1.0;

      osd.background_opacity = 1.0;

      shell = {
        font_family = lib.mkForce "Inter Display SemiBold";
        ui_scale = 1.1;

        launcher.default_view = "all";
      };

      theme = {
        builtin = "Catppuccin";
        mode = "dark";
        wallpaper_scheme = "m3-content";
      };

      wallpaper.default.path = "${config.stylix.image}";

      widget = {
        control-center = {
          custom_image = "${../assets/icons/nixos.svg}";
          custom_image_colorize = true;
          glyph = "";
        };

        sysmon = {
          highlight_color = "primary";
          show_value = true;
          visualization = "none";
        };

        tray.drawer = true;

        volume.mute_color = "primary";
      };
    };
  };
}
