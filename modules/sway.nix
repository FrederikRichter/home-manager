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
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
        config.sway.default = [ "wlr" "gtk" ];
    };

    wayland.windowManager.sway = {
        enable = true;
        #package = swayfx;
        systemd.enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
            # wait until new change is merged
            output = {
                    DP-1 = {
                            # hdr="on";
                            render_bit_depth = "10";
                            adaptive_sync = "on";
                            subpixel = "rgb";
                            allow_tearing = "true";
                        };
                };

            modifier = "Mod4";
            floating.modifier = "Mod4";

            floating.titlebar = false;
            window.titlebar = false;
            terminal = "kitty";

            # bars = [{"command" = "${waybar}/bin/waybar";}];
            bars = [];
            # keybindings (clear first)
            keybindings =  {
            Print = ''exec grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
            "${modifier}+Return" = ''exec kitty --hold sh -c "${tmux}/bin/tmux attach || ${tmux}/bin/tmux new"'';
            "${modifier}+Shift+Return" = ''exec kitty --hold sh -c "${tmux}/bin/tmux"'';

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
            "${modifier}+e" = "exec ${nautilus}/bin/nautilus";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+o" = "exec ${wofi}/bin/wofi -S drun -i --allow-images --no-actions";
            "${modifier}+n" = "exec ${wofi}/bin/wofi --dmenu --prompt='Enter nixpkg: ' | xargs -I {} kitty --hold sh -c 'nix shell nixpkgs#{} --impure'";
            
            };
        };
        extraConfig = ''
            # sway fx:
            # shadows enable

            input "type:keyboard" {
                xkb_layout us
                    xkb_options caps:swapescape
            }
            input "type:touchpad" {
                natural_scroll enabled
            }
            default_border none
            default_floating_border none
            gaps inner 10

            # Brightness
            bindsym XF86MonBrightnessDown exec light -U 10
            bindsym XF86MonBrightnessUp exec light -A 10

            # Volume
            bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
            bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
            bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

            focus_on_window_activation focus
            focus_follows_mouse no
            '';
    };
    home.sessionVariables = {
        _JAVA_AWT_WM_NONREPARENTING = 1;
        WLR_RENDERER="vulkan";
        WLR_DRM_NO_MODIFIERS=1;
    };
}
