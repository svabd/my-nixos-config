# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    ./../../modules/nixos/steam.nix
    ./../../modules/nixos/hyprland.nix
  ];
  services.displayManager.sddm.enable = lib.mkForce false;
services.displayManager.plasma-login-manager.enable = lib.mkForce false;
services.desktopManager.plasma6.enable = lib.mkForce false;
  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "svabd-nixos-portable";

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
    neovim
    tuigreet
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

  services.gvfs.enable = true;
  
  services.udisks2.enable = true;

  # Disable systemd-boot if it was enabled by default
boot.loader.systemd-boot.enable = false;

boot.loader.efi = {
  # Prevent NixOS from modifying the current host computer's NVRAM variables.
  # This keeps your portable USB completely independent of the machine it's plugged into.
  canTouchEfiVariables = false;
};

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev"; # "nodev" tells GRUB we are installing via EFI, not standard MBR
  
  # THIS IS THE CORRECT OPTION NAME:
  # It forces GRUB to install to the fallback EFI path (\EFI\BOOT\BOOTX64.EFI) 
  # which allows any computer's BIOS to see and boot the drive automatically.
  efiInstallAsRemovable = true;
};

  fileSystems."/" = {
    device = "/dev/mapper/luks-5c34bc27-2798-4ef2-8a09-a2b284d1b39b";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-5c34bc27-2798-4ef2-8a09-a2b284d1b39b".device = "/dev/disk/by-uuid/5c34bc27-2798-4ef2-8a09-a2b284d1b39b";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7B3C-A4FC";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  services.openssh.enable = false;

  system.stateVersion = "25.11";
}
