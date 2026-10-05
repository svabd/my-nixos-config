{
  description = "Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {
    self,
    nixpkgs,
    nvf,
    lib,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations."default" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
	nvf.nixosModules.default
        ./hosts/default/configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.sv_abd = import ./hosts/default/home.nix;
        }
        {
          options = {
            mySystem = {
              updateScript = lib.mkOption {
                type = lib.types.str;
                default = "sudo zsh /home/sv_abd/my-nixos-config/bash/system.sh";
                description = "The primary username for this machine.";
              };
            };
          };
        }
      ];
    };
    nixosConfigurations."portable" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {nix.settings.experimental-features = ["nix-command" "flakes"];}
          nvf.nixosModules.default
          ./hosts/portable/configuration.nix
          inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.sv_abd = import ./hosts/portable/home.nix;
          }
          {
             options = {
               mySystem = {
                 updateScript = lib.mkOption {
                   type = lib.types.str;
                   default = "sudo zsh /home/sv_abd/my-nixos-config/bash/portable.sh";
                   description = "The primary username for this machine.";
                 };
               };
             };
           }
        ];
    };
  };
}
