# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./../../modules/nixos/steam.nix
    ./../../modules/nixos/hyprland.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-08b95d12-2e5d-499b-afc4-26333f868c7b".device = "/dev/disk/by-uuid/08b95d12-2e5d-499b-afc4-26333f868c7b";
  networking.hostName = "nixos";

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    git
    nvim
  ];

  hardware = {
    #Opengl
    graphics.enable = true;

    #Most wayland compositors need this
    nvidia.modesetting.enable = true;
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

  # 1. Enable Zsh system-wide
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lh --icons --git";
      la = "eza -lah --icons --git";
      tree = "eza --tree --icons";
      grep = "rg --color=auto";
      update = "sudo zsh /home/sv_abd/my-nixos-config/bash/system.sh";
      collect = "sudo zsh /home/sv_abd/my-nixos-config/bash/nixos-garbage-collect.sh";
    };

    histSize = 10000;

    # Optional: Configure Oh My Zsh globally
    ohMyZsh = {
      enable = true;
      plugins = ["git" "sudo"];
      theme = "robbyrussell"; # Choose your theme
    };
  };
  
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
          nix.enable = true;
          markdown.enable = true;
          rust.enable = true;
        };
      };
    };
  };



  services.openssh.enable = false;

  system.stateVersion = "25.11";
}
