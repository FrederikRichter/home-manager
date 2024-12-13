{config, pkgs, inputs, username, ... }:
let	
	# create nix file loader function
	modulesDir = ./modules;
	moduleFiles = builtins.filter
	(f: builtins.match ".*\\.nix" f != null)
	(builtins.attrNames (builtins.readDir modulesDir));


    inherit pkgs;
    inherit inputs;
    inherit username;
in
{
	# Setup home constants
	home.username = "${username}";
	home.homeDirectory = "/home/${username}";

	home.stateVersion = "24.05";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	targets.genericLinux.enable = true;

	# load all nix files from ./modules
	imports = map (f: modulesDir + "/${f}") moduleFiles ++ [ inputs.stylix.homeManagerModules.stylix ];

	# define home packages
	home.packages = with pkgs; [
	# cli
        btop
        neofetch
		htop
		yt-dlp
		powertop
        typst
		thefuck
        nixvim
        hugo
        wakeonlan
# dev/libs
        gvfs
        udiskie
        usbutils
        libnotify
        bash
        dconf
        i2p
        fzf
        gdb
		unzip
		ripgrep
		gcc
		wget
		gnupg
		gnumake
		coreutils
		ffmpeg-full
        libsecret
		cmake
        swaylock
        swayidle
        wl-clipboard
        wofi
        slurp
        vesktop
        pulseaudio
        grim
        cbonsai
        tor
	# python
		python312Full
	# append gl dependent programs
		] ++  [ #map (mkgl)
		firefox
        xournalpp
		tdesktop
		inkscape
        signal-desktop
        discord
        pavucontrol
        mpv
        spotify
        simplex-chat-desktop
        zathura
		];
	
	# direct file access
	home.file = {
	};
	
	# set session vars
	home.sessionVariables = {
        EDITOR="nvim";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
        NIXPKGS_ALLOW_UNFREE=1;
	};
}
