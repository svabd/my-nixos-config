{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    hyprland
    tuigreet
  ];

  # greetd with tuigreet: shows a login prompt on boot, and
  # launches Hyprland automatically once you enter your credentials.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
  };
}
