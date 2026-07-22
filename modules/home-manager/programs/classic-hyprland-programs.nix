{pkgs, ...}: {
  home.packages = with pkgs; [
    (
      pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )
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
