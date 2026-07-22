{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations."default" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
        ./hosts/default/configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.sv_abd = import ./hosts/default/home.nix;
        }
      ];
    };
  };
}
