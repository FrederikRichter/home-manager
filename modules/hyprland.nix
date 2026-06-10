{ config, pkgs, lib, ... }:

let
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  terminal = "${pkgs.foot}/bin/foot";
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # Gamma
    services.hyprsunset = {
        enable = true;
        extraArgs = [
                "--gamma_max" "140" 
                "--gamma" "100"
                "--identity"
            ];
        systemdTarget = "hyprland-session.target";
    };


    programs.tofi = {
        enable = true;
            settings = {
                font-size = lib.mkForce "20";
                corner-radius = "16";
            };
        };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;

      systemd.enable = true;
      systemd.variables = [ "--all" ];

      settings = {
        exec-once = [
          "noctalia-shell"
        ];

        "$mod" = "SUPER";

        debug.disable_logs = false;

        ecosystem = {
          no_update_news = true;
        };

        cursor = {
            no_hardware_cursors = true;
        };
        misc = {

          focus_on_activate = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        animations = {
          enabled = false;
        };

        input = {
          kb_variant = "altgr-intl";

          follow_mouse = 2;

          touchpad = {
            tap-to-click = 0;
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 10;
          gaps_out = 10;
          border_size = 0;
          layout = "dwindle";
          allow_tearing = true;
        };

            layerrule = {
                name  = "tofi-layerrule99";
                match = { namespace = "launcher" ; };
                blur = false;
                ignore_alpha = 0.0;
            };


        decoration = {
          rounding = 8;
          rounding_power = 3.0;

          blur = {
            enabled = false;
          };

          shadow = {
            enabled = false;
          };
        };

        bind = [
          # Terminal
          "$mod, Return, exec, ${terminal} -e ${pkgs.zsh}/bin/zsh -c '${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new'"
          "$mod SHIFT, Return, exec, ${terminal} --hold sh -c '${pkgs.tmux}/bin/tmux'"

          # Window management
          "$mod, q, killactive"

          # Focus movement
          "$mod, ${left}, movefocus, l"
          "$mod, ${down}, movefocus, d"
          "$mod, ${up}, movefocus, u"
          "$mod, ${right}, movefocus, r"

          # Window movement
          "$mod SHIFT, ${left}, movewindow, l"
          "$mod SHIFT, ${down}, movewindow, d"
          "$mod SHIFT, ${up}, movewindow, u"
          "$mod SHIFT, ${right}, movewindow, r"

          # Workspace switching
          "$mod, a, workspace, 1"
          "$mod, s, workspace, 2"
          "$mod, d, workspace, 3"
          "$mod, f, workspace, 4"

          # Move to workspace
          "$mod SHIFT, a, movetoworkspace, 1"
          "$mod SHIFT, s, movetoworkspace, 2"
          "$mod SHIFT, d, movetoworkspace, 3"
          "$mod SHIFT, f, movetoworkspace, 4"

          # Workspace back and forth
          "$mod, Tab, workspace, previous"

          # Applications
          "$mod, e, exec, ${pkgs.xfce.thunar}/bin/thunar"
          # "$mod, o, exec, ${pkgs.wofi}/bin/wofi -S drun -i --allow-images --no-actions"
          "$mod, o, exec, ${pkgs.tofi}/bin/tofi-drun --drun-launch=true"


          # System
          "$mod SHIFT, r, exec, hyprctl reload"

          # Media keys
          ", XF86MonBrightnessDown, exec, hyprctl hyprsunset gamma -5"
          ", XF86MonBrightnessUp, exec, hyprctl hyprsunset gamma +5"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ];
      };
    };
  };
}
