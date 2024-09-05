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
        wrapperFeatures.gtk = true;
        config = rec {
            modifier = "Mod4";
            floating.modifier = "Mod4";

            floating.border = 0;
            window.border = 0;

            focus.followMouse = true;

            terminal = "kitty";

            # bars = [{"command" = "${waybar}/bin/waybar";}];

            # keybindings
            keybindings = mkOptionDefault {
            Print = ''exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
            "${modifier}+q" = "kill";
            "${modifier}+${left}" = "focus left; exec $movemouse";
            "${modifier}+${down}" = "focus down; exec $movemouse";
            "${modifier}+${up}" = "focus up; exec $movemouse";
            "${modifier}+${right}" = "focus right; exec $movemouse";

            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";

            "${modifier}+a" = "workspace number 1";
            "${modifier}+b" = "workspace number 2";
            "${modifier}+c" = "workspace number 3";
            "${modifier}+d" = "workspace number 4";

            "${modifier}+Shift+a" = "move container to workspace number 1";
            "${modifier}+Shift+b" = "move container to workspace number 2";
            "${modifier}+Shift+c" = "move container to workspace number 3";
            "${modifier}+Shift+d" = "move container to workspace number 4";

            "${modifier}+Shift+r" = "restart";
            };

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
