{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home.packages = with pkgs; [
    hyprland
  ];
}
