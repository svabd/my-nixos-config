# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./../../modules/nixos/configuration.nix
  ];

  mySystem.updateCommand = "sudo zsh /home/sv_abd/my-nixos-config/bash/portable.sh";
 
  services.displayManager.sddm.enable = lib.mkForce false;
  services.displayManager.plasma-login-manager.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = lib.mkForce false;
  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "svabd-nixos-portable";

  # Portable drive: boot on unknown hardware
  hardware.enableAllHardware = true;
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "uas"
    "sd_mod"
    "sdhci_pci"
    "usbhid"
    "thunderbolt"
  ];

  # Actually load the proprietary Nvidia driver for Hyprland
  services.xserver.videoDrivers = ["nvidia"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7B3C-A4FC";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  services.openssh.enable = false;

  system.stateVersion = "25.11";
}
