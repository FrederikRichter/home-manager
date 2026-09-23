{pkgs, ...}:
let
  hdrSdrBrightness = pkgs.writeShellScriptBin "hdr-sdr-brightness" ''
    STEP="$1" # Pass float step, e.g., 0.2 or -0.2

    # 1. Fetch active monitors from Hyprland IPC
    MONITORS_JSON=$(${pkgs.hyprland}/bin/hyprctl monitors -j)

    # 2. Target eDP-1 on Laptop, or first active DP-* connection on PC
    TARGET_MON=$(echo "$MONITORS_JSON" | ${pkgs.jq}/bin/jq -r '
      (map(select(.name == "eDP-1"))[0].name) // 
      (map(select(.name | startswith("DP-")))[0].name) // 
      empty
    ')

    if [ -z "$TARGET_MON" ] || [ "$TARGET_MON" = "null" ]; then
      exit 0
    fi

    # 3. Extract current monitor info and sdrBrightness (default to 1.0 if null)
    MON_INFO=$(echo "$MONITORS_JSON" | ${pkgs.jq}/bin/jq -r ".[] | select(.name==\"$TARGET_MON\")")
    CURRENT_VAL=$(echo "$MON_INFO" | ${pkgs.jq}/bin/jq -r '.sdrBrightness // 1.0')

    # 4. Calculate new value using awk for floating-point arithmetic
    NEW_VAL=$(echo "$CURRENT_VAL $STEP" | ${pkgs.gawk}/bin/gawk '{
      res = $1 + $2;
      if (res < 0.2) res = 0.2; # Floor limit
      if (res > 10.0) res = 10.0; # Ceiling limit
      printf "%.2f", res
    }')

    # 5. Apply update via Hyprland IPC
    ${pkgs.hyprland}/bin/hyprctl keyword monitor "$TARGET_MON, highres, auto, 1, cm, hdr, sdrbrightness, $NEW_VAL"
  '';
in {
  home.packages = [ hdrSdrBrightness ];

  wayland.windowManager.hyprland.settings = {
    binde = [
      ", XF86MonBrightnessUp, exec, hdr-sdr-brightness 1"
      ", XF86MonBrightnessDown, exec, hdr-sdr-brightness -1"
    ];
  };
}
