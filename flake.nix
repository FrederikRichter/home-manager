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
    };
    outputs = {nixpkgs, ... }@inputs:
        let
        username = builtins.getEnv "USER";
        x86_system = "x86_64-linux";
        x86_pkgs = import nixpkgs {
            inherit x86_system;
            config.allowUnfree = true;
        };

        aarch64_system = "aarch64-linux";
        aarch64_pkgs = import nixpkgs {
            inherit aarch64_system;
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
        homeConfigurations."fredpad" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = aarch64_pkgs;
            modules = [ ./hosts/base.nix ./hosts/fredpad.nix stylix ];
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
