{
  description = "Home Manager configuration flake";

  inputs = {
    # Specify the version of Nixpkgs you want to use
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Specify the matching version of Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # --- CHANGE THESE TO MATCH YOUR SYSTEM ---
    system = "x86_64-linux"; # Use "aarch64-linux", "x86_64-darwin", or "aarch64-darwin" if needed
    username = "sv_abd";
    # -----------------------------------------

    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home.nix file here
      modules = [
        ./home.nix
        ./hyprland.nix
      ];

      # Optionally pass arguments from the flake into home.nix
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
