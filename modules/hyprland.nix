{ config, pkgs, lib, inputs, ... }:

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

  # Monitor properties are defined per-host; reuse them as the base spec so
  # that only sdrbrightness changes when adjusting it at runtime.
  monitorSettings = config.wayland.windowManager.hyprland.settings.monitor or { };
  baseMonitor = lib.generators.toLua { } (
    removeAttrs (if lib.isAttrs monitorSettings then monitorSettings else { }) [ "output" ]
  );

  sdrBrightnessAdjust = lua ''
    (function()
      local base = ${baseMonitor}
      local levels = {}
      local min_level = 0.02
      local max_level = 3.0
      return function(delta)
        local monitor = hl.get_active_monitor()
        if monitor == nil then
          return
        end
        local name = monitor.name
        if levels[name] == nil then
          levels[name] = base.sdrbrightness or 1.0
        end
        local level = levels[name] + delta
        if level < min_level then level = min_level end
        if level > max_level then level = max_level end
        levels[name] = level
        local spec = {}
        for key, value in pairs(base) do
          spec[key] = value
        end
        spec.output = name
        spec.sdrbrightness = level
        hl.monitor(spec)
      end
    end)()
  '';
in
{

  options = {
    hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      systemd.enable = true;
      systemd.variables = [ "--all" ];

      settings = {
        mod = {
          _var = "SUPER";
        };

        sdr_brightness_adjust = {
          _var = sdrBrightnessAdjust;
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
            direct_scanout = 0;
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

          debug = {
            disable_logs = false;
          };
        };

        env = [
          { _args = [ "NIXOS_OZONE_WL" "1" ]; }
          { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "wayland" ]; }
        ];

        layer_rule = {
          name = "tofi-layerrule99";
          match = { namespace = "launcher"; };
          blur = false;
          ignore_alpha = 0.0;
        };

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

        bind = [
          # Screenshot
          (bind "Print" (lua ''hl.dsp.exec_cmd("grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png")''))

          # Terminal
          (bind (modKey "Return") (lua ''hl.dsp.exec_cmd("${terminal} -e ${pkgs.zsh}/bin/zsh -c '${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new'")''))
          (bind (modKey "SHIFT + Return") (lua ''hl.dsp.exec_cmd("${terminal} --hold sh -c '${pkgs.tmux}/bin/tmux'")''))

          # Window management
          (bind (modKey "q") (lua "hl.dsp.window.kill()"))

          # Focus movement
          (bind (modKey left) (lua ''hl.dsp.focus({ direction = "left" })''))
          (bind (modKey down) (lua ''hl.dsp.focus({ direction = "down" })''))
          (bind (modKey up) (lua ''hl.dsp.focus({ direction = "up" })''))
          (bind (modKey right) (lua ''hl.dsp.focus({ direction = "right" })''))

          # Window movement
          (bind (modKey "SHIFT + ${left}") (lua ''hl.dsp.window.move({ direction = "left" })''))
          (bind (modKey "SHIFT + ${down}") (lua ''hl.dsp.window.move({ direction = "down" })''))
          (bind (modKey "SHIFT + ${up}") (lua ''hl.dsp.window.move({ direction = "up" })''))
          (bind (modKey "SHIFT + ${right}") (lua ''hl.dsp.window.move({ direction = "right" })''))

          # Workspace switching
          (bind (modKey "a") (lua "hl.dsp.focus({ workspace = 1 })"))
          (bind (modKey "s") (lua "hl.dsp.focus({ workspace = 2 })"))
          (bind (modKey "d") (lua "hl.dsp.focus({ workspace = 3 })"))
          (bind (modKey "f") (lua "hl.dsp.focus({ workspace = 4 })"))

          # Move to workspace
          (bind (modKey "SHIFT + a") (lua "hl.dsp.window.move({ workspace = 1 })"))
          (bind (modKey "SHIFT + s") (lua "hl.dsp.window.move({ workspace = 2 })"))
          (bind (modKey "SHIFT + d") (lua "hl.dsp.window.move({ workspace = 3 })"))
          (bind (modKey "SHIFT + f") (lua "hl.dsp.window.move({ workspace = 4 })"))

          # Workspace back and forth
          (bind (modKey "Tab") (lua ''hl.dsp.focus({ workspace = "previous" })''))

          # Applications
          (bind (modKey "e") (lua ''hl.dsp.exec_cmd("${pkgs.nemo}/bin/nemo")''))
          (bind (modKey "o") (lua ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")''))

          # System
          (bind (modKey "SHIFT + r") (lua ''hl.dsp.exec_cmd("hyprctl reload")''))

          # Media keys
          (bindWith "XF86AudioRaiseVolume" (lua ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+")'') { locked = true; repeating = true; })
          (bindWith "XF86AudioLowerVolume" (lua ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-")'') { locked = true; repeating = true; })
          (bindWith "XF86AudioMute" (lua ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle")'') { locked = true; repeating = true; })

          # SDR brightness (HDR mode)
          (bindWith "XF86MonBrightnessDown" (lua "function() sdr_brightness_adjust(-0.2) end") { locked = true; repeating = true; })
          (bindWith "XF86MonBrightnessUp" (lua "function() sdr_brightness_adjust(0.2) end") { locked = true; repeating = true; })
        ];
      };
    };
  };
}
