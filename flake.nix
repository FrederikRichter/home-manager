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
        system = "x86_64-linux";

        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };

    in {
        homeConfigurations."thinkpad" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./hosts/base.nix ./hosts/thinkpad.nix inputs.stylix.homeManagerModules.stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
        };
        homeConfigurations."battlestation" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./hosts/base.nix ./hosts/battlestation.nix inputs.stylix.homeManagerModules.stylix ];
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
            };
        };
    };
}
