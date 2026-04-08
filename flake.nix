{
    description = "Home Manager configuration by FrederikRichter";

    inputs = {
# Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixvim = {
            url = "github:FrederikRichter/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:danth/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        noctalia = {
            url = "github:noctalia-dev/noctalia-shell";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, ... }@inputs:
        let
        username = builtins.getEnv "USER";
        x86_system = "x86_64-linux";
        x86_pkgs = import nixpkgs {
            inherit x86_system;
            config.allowUnfree = true;
        };

        stylix = inputs.stylix.homeModules.stylix; 
    in {
        homeConfigurations."thinkpad" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = x86_pkgs;
            modules = [ ./hosts/base.nix ./hosts/thinkpad.nix stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
        };
        homeConfigurations."ideapad" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = x86_pkgs;
            modules = [ ./hosts/base.nix ./hosts/ideapad.nix stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
        };
        homeConfigurations."battlestation" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = x86_pkgs;
            modules = [ ./hosts/base.nix ./hosts/battlestation.nix stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
        };
    };
}
