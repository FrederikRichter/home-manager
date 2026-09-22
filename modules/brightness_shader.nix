# ---------------------------------------------------------------------------
# NixOS / Home-Manager integration for hypr-hdr-control
# ---------------------------------------------------------------------------
# The helper script [src path differs from ../!] (../bin/hypr-hdr-control) and the fragment shader
# (../shader/hdr_brightness.frag) are kept as separate files and referenced
# here, so you can edit/debug them directly. The shader is exposed to the
# script through HDR_BRIGHTNESS_TEMPLATE.
# ---------------------------------------------------------------------------
{ pkgs, lib, ... }:

let
  # writeShellApplication supplies the shebang, so drop the script's own.
  hypr-hdr-control-body = lib.removePrefix "#!/usr/bin/env bash\n" (builtins.readFile ./moduledata/brightness_shader/bin/hypr-hdr-control);

  hdr-brightness-frag = pkgs.writeText "hdr_brightness.frag" (builtins.readFile ./moduledata/brightness_shader/shader/hdr_brightness.frag);

  hypr-hdr-control = pkgs.writeShellApplication {
    name = "hypr-hdr-control";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
      gawk
      hyprland
      libnotify
    ];
    text = ''
      export HDR_BRIGHTNESS_TEMPLATE=${lib.escapeShellArg (toString hdr-brightness-frag)}
    '' + hypr-hdr-control-body;
  };
in
{
  home.packages = [ hypr-hdr-control ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [ "hypr-hdr-control apply" ];

    bind = [
      ", XF86MonBrightnessUp, exec, hypr-hdr-control up 0.2"
      ", XF86MonBrightnessDown, exec, hypr-hdr-control down 0.2"
      "SUPER SHIFT, b, exec, hypr-hdr-control reset"
      "SUPER CONTROL, b, exec, hypr-hdr-control off"
    ];
  };
}
