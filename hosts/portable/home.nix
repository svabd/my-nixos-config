{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default

    #config
    ./../../modules/home-manager/config/hyprland-config-1.nix
    ./../../modules/home-manager/config/vscodium-config-1.nix
    ./../../modules/home-manager/config/ytdl-sub-jellyfin-setup.nix
    ./../../modules/home-manager/config/zsh-config.nix
    ./../../modules/home-manager/config/update-portable.nix

    #simple programs
    ./../../modules/home-manager/programs/tree-sitter.nix
  ];
  nixpkgs.config.allowUnfree = true;

  home.username = "sv_abd";
  home.homeDirectory = "/home/sv_abd";

  programs.git = {
    enable = true;
    settings.user.name = "aidan duisman";
    settings.user.email = "duismana@gmail.com";
  };

  backupFileExtension = "backup";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    docker
    docker-compose
    direnv
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
    (prismlauncher.override {
      jdks = [
        temurin-bin-8
        temurin-bin-17
        temurin-bin-21
        temurin-bin-25
      ];
    })
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.noctalia = {
    enable = true;

    # Optional settings structure writing to ~/.config/noctalia/config.toml
    settings = {
      bar = {
        position = "top";
        transparent = true;
      };
    };
  };

  # 1. Define the universal cursor configuration
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # 2. Sync with GTK settings directly
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
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
