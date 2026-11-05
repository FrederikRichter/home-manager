{ pkgs, lib, ... }:

{
  home.username = "frederik";
  home.homeDirectory = "/home/frederik";

  programs.home-manager.enable = true;

  home.stateVersion = lib.mkDefault "25.11";

  imports = [
    ../modules
  ];

  home.packages = with pkgs; [
    android-tools
    antigravity-cli
    ausweisapp
    bash
    blender
    btop
    coreutils
    dconf
    dosfstools
    fastfetch
    ffmpeg-full
    fzf
    gnumake
    gtrash
    grim
    helium
    htop
    hugo
    libnotify
    libreoffice-qt
    libsecret
    lm_sensors
    localsend
    loupe
    nemo
    nixvim
    ntfs3g
    overskride
    pavucontrol
    powertop
    qalculate-qt
    ripgrep
    rquickshare
    signal-desktop
    slurp
    spotify
    swayidle
    transmission_4
    tree
    typst
    udiskie
    unrar
    unzip
    usbutils
    vlc
    wakeonlan
    wget
    wl-clipboard
    wofi
    yt-dlp
    zathura
    zig
    zotero
    llm-agents.dsh
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GSK_RENDERER = "ngl";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];
  };

  # Apply nixpkgs config to user-level nix commands.
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      permittedInsecurePackages = [ "firefox-esr-140-bin-unwrapped-140.17.0esr" ];
    }
  '';
}
