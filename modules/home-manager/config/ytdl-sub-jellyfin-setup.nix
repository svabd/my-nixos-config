{pkgs, ...}: {
  imports = [
    ./../programs/ytdl-sub.nix
    ./../programs/jellyfin.nix
  ];

  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;
  };
}
