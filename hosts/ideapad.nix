{ config, pkgs, lib, ... }:
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

  externalMonitor = {
    output = "HDMI-A-1";
    mode = "4096x2160@50.00Hz";
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
in
{
targets.genericLinux.enable = lib.mkForce false;

hyprland.enable = true;

wayland.windowManager.hyprland = {
    settings.monitor = [
      internalMonitor
      externalMonitor
    ];

    extraConfig = ''
      local internal_monitor = ${lib.generators.toLua { } internalMonitor}

      local function auto_toggle_edp(removed_name)
        local has_external = false
        for _, m in ipairs(hl.get_monitors()) do
          local mname = (type(m) == "userdata" or type(m) == "table") and m.name or tostring(m)
          if mname ~= "eDP-1" and (not removed_name or mname ~= removed_name) then
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
        local mname = (type(mon) == "userdata" or type(mon) == "table") and mon.name or tostring(mon)
        if mname ~= "eDP-1" then
          hl.monitor({ output = "eDP-1", disabled = true })
        else
          auto_toggle_edp(nil)
        end
      end)

      hl.on("monitor.removed", function(mon)
        local mname = (type(mon) == "userdata" or type(mon) == "table") and mon.name or tostring(mon)
        if mname ~= "eDP-1" then
          auto_toggle_edp(mname)
        end
      end)

      hl.on("hyprland.start", function()
        auto_toggle_edp(nil)
      end)

      auto_toggle_edp(nil)
    '';
};


# MPV
programs.mpv.config = {
    hwdec="vulkan";
    gpu-api="vulkan";
    gpu-context="waylandvk";
    profile="high-quality";
};

home.stateVersion = "25.11";
}
