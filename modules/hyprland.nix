{config, pkgs, lib, ... }: 
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
            
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
        animation=global,0
        decoration:blur:enabled = false
        decoration:shadow:enabled = false
        misc:vfr = true
        ecosystem:no_update_news = true
    '';
    systemd.enable = true;
    systemd.variables = ["--all"];

    settings = {
      debug.disable_logs = false;
      # Input configuration
      input = {
        follow_mouse = 0; 
        
        touchpad = {
            tap-to-click = 0;
            natural_scroll = true;
        };
      };
    
      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 0;  # equivalent to default_border none
        layout = "dwindle";
        allow_tearing = true;
      };
      
      # Decoration settings
      decoration = {
        rounding = 0;
      };
      
      # Key bindings
      "$mod" = "SUPER";
      
      bind = [
        # Terminal
        "$mod, Return, exec, ${terminal} --hold sh -c '${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new'"
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
        "$mod, o, exec, ${pkgs.wofi}/bin/wofi -S drun -i --allow-images --no-actions"
        "$mod, n, exec, ${pkgs.wofi}/bin/wofi --dmenu --prompt='Enter nixpkg: ' | xargs -I {} ${terminal} --hold sh -c 'nix shell nixpkgs#{} --impure'"
        
        # System
        "$mod SHIFT, r, exec, hyprctl reload"
        
        # Media keys
        ", XF86MonBrightnessDown, exec, light -U 10"
        ", XF86MonBrightnessUp, exec, light -A 10"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +1%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -1%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        
        # Screenshot
        ", Print, exec, grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png"
      ];
      
      # Window focus behavior
      misc = {
        focus_on_activate = true;  # equivalent to focus_on_window_activation focus
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
  };
    };
}
