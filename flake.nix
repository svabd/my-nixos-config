{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
    url = "github:nix-community/home-manager/master"; # Master branch follows nixpkgs-unstable
    inputs.nixpkgs.follows = "nixpkgs";
  };
  };
  outputs = { self, nixpkgs, home-manager, ...} @ inputs: {
    nixosConfigurations."nixos-flakes-btw" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nix.settings.experimental-features = ["nix-command" "flakes"]; }
        ./configuration.nix
        home-manager.nixosModules.home-manager { # Import HM module
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.sv_abd = import /home/sv_abd/.config/home-manager/flake.nix;
        }
      ];
    };
  };
}
