{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {inputs, self, nixpkgs, ...}@inputs: {
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in
    {
      nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem = {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
  }
}
