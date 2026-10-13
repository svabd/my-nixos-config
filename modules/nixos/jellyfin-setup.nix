{...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true; # Automatically opens port 8096 for local network access
    user = "sv_abd";
    extraGroups = ["video" "render"];
  };
}
