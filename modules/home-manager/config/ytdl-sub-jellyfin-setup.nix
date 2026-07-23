{pkgs, ...}: {
  imports = [
    ./../programs/ytdl-sub.nix
    ./../programs/jellyfin.nix
  ];

  # 1. Install the package to your user profile
  home.packages = [pkgs.jellyfin-web];

  # 2. Create a user-level background service
  systemd.user.services.jellyfin = {
    Unit = {
      Description = "Jellyfin Media Server (Home Manager Service)";
      After = ["network.target"];
    };
    Service = {
      Type = "simple";
      # Points Jellyfin to write configuration data inside your home folder
      ExecStart = ''
        ${pkgs.jellyfin}/bin/jellyfin \
          --datadir ~/.config/jellyfin/data \
          --configdir ~/.config/jellyfin/config \
          --logdir ~/.config/jellyfin/log \
          --cachedir ~/.config/jellyfin/cache
      '';
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
