{ config, lib, ... }:

let
  internalMonitor = {
    output = "eDP-1";
    mode = "highres";
    position = "auto";
    scale = 2;
    bitdepth = 10;
    cm = "hdr";
    vrr = 1;
    brightness = 1.0;
    sdrsaturation = 1.0;
    sdr_min_luminance = 0.02;
    sdr_max_luminance = 400;
    max_luminance = 1000;
    disabled = false;
  };

  hdmi = {
    output = "HDMI-A-1";
    mode = "preferred";
    position = "auto-left";
    scale = 1;
  };

  dp2 = {
    output = "DP-2";
    mode = "preferred";
    position = "auto";
  };
in
{
  options.ideapad.tv.enable = lib.mkEnableOption "TV display profile with automatic internal display handling";

  config = {
    hyprland.enable = true;

    wayland.windowManager.hyprland = {
      settings = {
        monitor = [
          internalMonitor
          (if config.ideapad.tv.enable then config.hyprland.tvPreset else hdmi)
          dp2
        ];
      } // lib.optionalAttrs (!config.ideapad.tv.enable) {
        workspace_rule = [
          {
            workspace = "5";
            monitor = "HDMI-A-1";
            default = true;
          }
          {
            workspace = "1";
            monitor = "eDP-1";
          }
          {
            workspace = "2";
            monitor = "eDP-1";
          }
          {
            workspace = "3";
            monitor = "eDP-1";
          }
          {
            workspace = "4";
            monitor = "eDP-1";
            default = true;
          }
        ];
      };

      # In TV mode any external display disables the internal one;
      # otherwise only a display connected via DP-2 does.
      extraConfig = ''
        local internal_monitor = ${lib.generators.toLua { } internalMonitor}

        local function is_external_monitor(mon)
          local mname = (type(mon) == "userdata" or type(mon) == "table") and mon.name or tostring(mon)
          ${if config.ideapad.tv.enable
            then ''return mname ~= "eDP-1" and mname ~= "FALLBACK"''
            else ''return mname == "DP-2"''}
        end

        local function check_external()
          local has_external = false
          for _, m in ipairs(hl.get_monitors()) do
            if is_external_monitor(m) then
              has_external = true
              break
            end
          end

          if has_external then
            hl.monitor({ output = "eDP-1", disabled = true })
          else
            hl.monitor(internal_monitor)
          end
        end

        hl.on("monitor.added", function(mon)
          if is_external_monitor(mon) then
            hl.monitor({ output = "eDP-1", disabled = true })
          end
        end)

        hl.on("monitor.removed", function()
          check_external()
        end)

        hl.on("hyprland.start", function()
          check_external()
        end)

        check_external()
      '';
    };

    programs.mpv.config.hwdec = "vulkan";
    programs.foot.settings.main.font = lib.mkForce "monospace:size=12";
  };
}

