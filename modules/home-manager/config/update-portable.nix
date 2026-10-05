{config, lib, pkgs, ...}: {
  imports = [
    ./update.nix
  ];

  config = {
    updateScript = "sudo zsh /home/sv_abd/my-nixos-config/bash/portable.sh";
  }
}
