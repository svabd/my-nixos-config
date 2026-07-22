{pkgs, ...}: {
  programs.vscodium.enable = true;
  home.packages = with pkgs; [
    vscodium
  ];
}
