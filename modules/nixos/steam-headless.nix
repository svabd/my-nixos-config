{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers."steam-headless" = {
    image = "ghcr.io/steam-headless/docker-steam-headless:latest";
    autoStart = true;
    
    # Required for the container to access the host graphics card
    environment = {
      DISPLAY = ":1";
      UNAME = "steamuser";
      # If using NVIDIA, uncomment below:
      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "all";
    };

    extraOptions = [
      "--device=/dev/dri:/dev/dri" # Intel/AMD GPU path
      "--gpus=all"              # Uncomment if using NVIDIA GPU
      "--ipc=host"
      "--cap-add=SYS_ADMIN"
    ];

    # Map persistent directories for your Steam downloads and app configurations
    volumes = [
      "/var/lib/steam-headless/home:/home/steamuser"
    ];

    # Open network ports for Web UI (VNC), Sunshine, and Moonlight connections
    ports = [
      "8083:8083"   # Web VNC interface for system configuration
      "47984-47990:47984-47990/tcp" 
      "47998-48000:47998-48000/udp"
      "48010:48010"
    ];
  };
}

