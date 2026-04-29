{config, pkgs, inputs, username, lib, ... }:
let	
	# create nix file loader function
	modulesDir = ../modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));
    # nixvim = inputs.nixvim.packages.${pkgs.system}.default.extend config.stylix.targets.nixvim.exportedModule;
    nixvim = inputs.nixvim.packages.${pkgs.system}.default;
    
    

	inherit pkgs;
	inherit inputs;
	inherit username;
in
{
	# Setup home constants
	home.username = "${username}";
	home.homeDirectory = "/home/${username}";


	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = lib.mkDefault true;

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles;

	# define home packages
	home.packages = with pkgs; [
    android-tools
    ausweisapp
	bash
	coreutils
	dconf
	dosfstools
	ffmpeg-full
	fzf
	gdb
    gtrash
	grim
	htop
	hugo
    keepassxc
    loupe
	libnotify
	libreoffice-qt6-fresh
	libsecret
    librewolf
	nixvim
	ntfs3g
	pavucontrol
	powertop
	ripgrep
	signal-desktop
	slurp
	swayidle
	telegram-desktop
	transmission_4
	typst
	udiskie
    unrar
	unzip
	usbutils
	wakeonlan
	wget
	wl-clipboard
    lm_sensors
	wofi
	yt-dlp
	zathura
    btop
    mpv
    overskride
    fastfetch
    tree
    vlc
    rquickshare
    overskride
    qalculate-qt
	];

	# set session vars
	home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = 1;
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        GSK_RENDERER="ngl"; # HOTFIX
        WEBKIT_DISABLE_COMPOSITING_MODE=1; # HOTFIX
	};

    systemd.user.sessionVariables = {
    };
}
