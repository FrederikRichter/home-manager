{ lib, pkgs, config, options, ... }:
with pkgs;
with lib;
let
  left = "h";
  down = "j";
  up = "k";
  right = "l";
in
{
    wayland.windowManager.sway = {
        enable = true;
        config = rec {
            modifier = "Mod4";
            floating.modifier = "Mod4";

            floating.border = 0;
            window.border = 0;

            focus.followMouse = true;

            terminal = "kitty";

            # bars = [{"command" = "${waybar}/bin/waybar";}];

            # keybindings
        };
        extraConfig = ''
            input "type:keyboard" {
                xkb_layout gb
                    xkb_options caps:swapescape
            }
        input "type:touchpad" {
            natural_scroll enabled
        }
        '';
    };
    home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
    };
}
