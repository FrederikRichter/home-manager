{ config, pkgs, lib, ... }:

let
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  terminal = "${pkgs.foot}/bin/foot";

  lua = lib.generators.mkLuaInline;

  bind = keys: dispatcher: {
    _args = [ keys dispatcher ];
  };

  bindWith = keys: dispatcher: opts: {
    _args = [ keys dispatcher opts ];
  };

  modKey = key: lua ''mod .. " + ${key}"'';

  startHyprlandScript = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      exec ${config.wayland.windowManager.hyprland.package}/bin/start-hyprland
    fi
  '';

  brightnessAdjust = lua ''
    (function()
      local levels = {}
      local min_level = 0.0
      local max_level = 3.0
      return function(delta)
        local monitor = hl.get_active_monitor()
        if monitor == nil then
          return
        end
        local name = monitor.name
        if levels[name] == nil then
          levels[name] = monitor.brightness or 1.0
        end
        local level = levels[name] + delta
        if level < min_level then level = min_level end
        if level > max_level then level = max_level end
        levels[name] = level
        hl.monitor({
          output = name,
          brightness = level,
        })
      end
    end)()
  '';

  directionBinds = [
    { key = left; dir = "left"; }
    { key = down; dir = "down"; }
    { key = up; dir = "up"; }
    { key = right; dir = "right"; }
  ];

  workspaceBinds = [
    { key = "a"; ws = "1"; }
    { key = "s"; ws = "2"; }
    { key = "d"; ws = "3"; }
    { key = "f"; ws = "4"; }
    { key = "g"; ws = "5"; }
  ];

  mediaBindOpts = {
    locked = true;
    repeating = true;
  };
in
{
  options = {
    hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";

      tvPreset = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        readOnly = true;
        description = "Shared HDR display preset for the HDMI-A-1 TV output.";
        default = {
          output = "HDMI-A-1";
          mode = "3840x2160@60.00Hz";
          position = "auto";
          scale = 2;
          bitdepth = 10;
          cm = "hdr";
          vrr = 1;
          brightness = 1.0;
          sdrsaturation = 1.0;
          sdr_min_luminance = 0.045;
          sdr_max_luminance = 250;
          min_luminance = 0.045;
          max_luminance = 387;
        };
      };
    };
  };

  config = lib.mkIf config.hyprland.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    programs.zsh.loginExtra = startHyprlandScript;
    programs.bash.profileExtra = startHyprlandScript;

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      settings = {
        mod = {
          _var = "SUPER";
        };

        brightness_adjust = {
          _var = brightnessAdjust;
        };

        config = {
          input = {
            kb_layout = "us";
            kb_variant = "altgr-intl";

            follow_mouse = 2;

            touchpad = {
              tap_to_click = 0;
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

          animations = {
            enabled = false;
          };

          render = {
            direct_scanout = false;
          };

          xwayland = {
            force_zero_scaling = true;
            use_nearest_neighbor = true;
          };

          cursor = {
            no_hardware_cursors = true;
          };

          misc = {
            focus_on_activate = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          ecosystem = {
            no_update_news = true;
          };
        };

        env = [
          { _args = [ "NIXOS_OZONE_WL" "1" ]; }
          { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "wayland" ]; }
        ];

        layer_rule = {
          name = "noctalia-launcher";
          match = { namespace = "launcher"; };
          blur = false;
          ignore_alpha = 0.0;
        };

        window_rule = [
          {
            name = "minecraft-fullscreen-title";
            match = {
              title = "(?i)^Minecraft.*";
            };
            fullscreen = true;
          }
          {
            name = "minecraft-fullscreen-class";
            match = {
              class = "(?i)^Minecraft.*";
            };
            fullscreen = true;
          }
          {
            name = "noscreenshare";
            match = {
              class = "^(org.telegram.desktop|signal|discord|nemo|org.keepassxc.KeePassXC)";
            };
            no_screen_share = true;
          }
        ];

        on = {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("${pkgs.noctalia}/bin/noctalia")
              end
            '')
          ];
        };

        bind =
          [
            (bind "Print" (lua ''hl.dsp.exec_cmd("${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png")''))

            (bind (modKey "Return") (lua ''hl.dsp.exec_cmd("${terminal} -e ${pkgs.zsh}/bin/zsh -c '${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new'")''))
            (bind (modKey "SHIFT + Return") (lua ''hl.dsp.exec_cmd("${terminal} --hold sh -c '${pkgs.tmux}/bin/tmux'")''))

            (bind (modKey "q") (lua "hl.dsp.window.close()"))
          ]
          ++ map (d: bind (modKey d.key) (lua ''hl.dsp.focus({ direction = "${d.dir}" })'')) directionBinds
          ++ map (d: bind (modKey "SHIFT + ${d.key}") (lua ''hl.dsp.window.move({ direction = "${d.dir}" })'')) directionBinds
          ++ map (w: bind (modKey w.key) (lua "hl.dsp.focus({ workspace = ${w.ws} })")) workspaceBinds
          ++ map (w: bind (modKey "SHIFT + ${w.key}") (lua "hl.dsp.window.move({ workspace = ${w.ws} })")) workspaceBinds
          ++ [
            (bind (modKey "Tab") (lua ''hl.dsp.focus({ workspace = "previous" })''))

            (bind (modKey "e") (lua ''hl.dsp.exec_cmd("${pkgs.nemo}/bin/nemo")''))
            (bind (modKey "o") (lua ''hl.dsp.exec_cmd("${pkgs.noctalia}/bin/noctalia msg panel-toggle launcher")''))

            (bind (modKey "SHIFT + r") (lua ''hl.dsp.exec_cmd("hyprctl reload")''))

            (bindWith "XF86AudioRaiseVolume" (lua ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+")'') mediaBindOpts)
            (bindWith "XF86AudioLowerVolume" (lua ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-")'') mediaBindOpts)
            (bindWith "XF86AudioMute" (lua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle")'') mediaBindOpts)

            (bindWith "XF86MonBrightnessDown" (lua "function() brightness_adjust(-0.2) end") mediaBindOpts)
            (bindWith "XF86MonBrightnessUp" (lua "function() brightness_adjust(0.2) end") mediaBindOpts)
          ];
      };
    };
  };
}

