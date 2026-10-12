{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.nvf.nixosModules.default
    ./standard-tools.nix
    ./../../modules/nixos/steam.nix
    ./../../modules/nixos/hyprland.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users.sv_abd = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  hardware.xpadneo.enable = true;

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [xpadneo];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
  };

  # Enable Bluetooth hardware and turn it on by default
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true; # Shows controller battery status
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  # Required system services for Noctalia's bar integration
  services.upower.enable = true;

  # GUI Bluetooth Manager (Optional, but useful for pairing)
  services.blueman.enable = true;

  services.displayManager.sddm.enable = lib.mkForce false;
  services.displayManager.plasma-login-manager.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = lib.mkForce false;
  nixpkgs.hostPlatform = "x86_64-linux";

  # Actually load the proprietary Nvidia driver for Hyprland
  services.xserver.videoDrivers = ["nvidia"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sv_abd = {
    isNormalUser = true;
    description = "aidan duisman";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    bash
    git
    neovim
    tuigreet
    google-chrome
  ];

  environment.sessionVariables = {
    # Forces Electron and Chromium apps (like Chrome/VS Code) to run natively in Wayland mode
    NIXOS_OZONE_WL = "1";

    # Required hardware acceleration strings for modern Nvidia drivers on Wayland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  hardware = {
    #Opengl
    graphics.enable = true;

    #Most wayland compositors need this
    nvidia = {
      # This turns on DRM modesetting, allowing Hyprland to boot
      modesetting.enable = true;

      # Required to make sure NixOS pulls in the correct Nvidia setup blocks
      powerManagement.enable = false;
      open = false;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      update = config.mySystem.updateCommand;
    };
  };

  services.openssh.enable = false;

  system.stateVersion = "25.11";

  services.gvfs.enable = true;

  services.udisks2.enable = true;

  programs.nvf = {
    enable = true;

    settings = {
      # Core options
      vim = {
        viAlias = true;
        vimAlias = true;
        preventJunkFiles = true;

        # Theme configuration
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        # Visual and UI elements
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;

        # File tree navigation
        filetree.neo-tree.enable = true;

        # Enable LSP globally here
        lsp.enable = true;

        # Treesitter and LSP Settings
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          enableDAP = true;

          # Enable specific language support seamlessly
          nix = {
            enable = true;
            format = {
              enable = true;
              type = ["alejandra"];
            };
          };
          markdown.enable = true;
          rust.enable = true;
        };
      };
    };
  };
}
