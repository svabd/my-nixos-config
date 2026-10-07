{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    tuigreet
  ];

  # Registers greetd as the persistent display manager slot handler
  services.displayManager.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        # Standard robust Wayland tuigreet command
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
      };
    };
  };

  security.polkit.enable = true;
}
