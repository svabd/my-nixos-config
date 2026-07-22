{pkgs, ...}: {
  home.programs.steam.enable = true;
  home.packages = with pkgs; [
    steam
  ];
}
