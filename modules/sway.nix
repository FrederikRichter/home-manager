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

            floating.titlebar = false;
            window.titlebar = false;
        
            focus.followMouse = true;
                
            defaultWorkspace = "1";

            bars = [
            {
                position = "top";
            }
            ];

            terminal = "kitty";

            # bars = [{"command" = "${waybar}/bin/waybar";}];

            # keybindings (clear first)
            keybindings = mkOptionDefault {
            Print = ''exec grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
            "${modifier}+Return" = ''exec kitty --hold sh -c "tmux attach || tmux new"'';
            "${modifier}+Shift+Return" = ''exec kitty --hold sh -c "tmux new"'';

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
            "${modifier}+s" = "workspace number 2";
            "${modifier}+d" = "workspace number 3";
            "${modifier}+f" = "workspace number 4";

            "${modifier}+Shift+a" = "move container to workspace number 1";
            "${modifier}+Shift+s" = "move container to workspace number 2";
            "${modifier}+Shift+d" = "move container to workspace number 3";
            "${modifier}+Shift+f" = "move container to workspace number 4";

            "${modifier}+Tab" = "workspace back_and_forth";
    
            "${modifier}+Shift+r" = "restart";
            "${modifier}+o" = "exec wofi -S drun";

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
            default_border none
            default_floating_border none
            gaps inner 10
            '';
    };
    home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
    };
}
