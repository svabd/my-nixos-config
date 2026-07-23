{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #config
    ./../../modules/home-manager/config/hyprland-config-1.nix
    ./../../modules/home-manager/config/vscodium-config-1.nix
    ./../../modules/home-manager/config/ytdl-sub-jellyfin-setup.nix

    #simple programs
  ];
  nixpkgs.config.allowUnfree = true;

  home.username = "sv_abd";
  home.homeDirectory = "/home/sv_abd";

  programs.git = {
    enable = true;
    settings.user.name = "aidan duisman";
    settings.user.email = "duismana@gmail.com";
  };

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    docker
    docker-compose
    direnv
    neovim
    tailscale
    google-chrome
    alejandra
    nixd
    nix-direnv
    ungoogled-chromium
    git
    gh
    siyuan
    mission-center
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  home.file = {
  };

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";

    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;
}
