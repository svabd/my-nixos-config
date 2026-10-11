{pkgs, ...}: {
  home.packages = with pkgs; [
    dunst
    libnotify
    awww
    kitty
    hyprlauncher
    xdg-desktop-portal-gtk
    kdePackages.dolphin
    font-awesome # Provides basic UI and status icons
    nerd-fonts.jetbrains-mono
    cargo
  ];
}
