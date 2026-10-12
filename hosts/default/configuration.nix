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
    ./../../modules/nixos/configuration.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-08b95d12-2e5d-499b-afc4-26333f868c7b".device = "/dev/disk/by-uuid/08b95d12-2e5d-499b-afc4-26333f868c7b";
  networking.hostName = "nixos";
}
