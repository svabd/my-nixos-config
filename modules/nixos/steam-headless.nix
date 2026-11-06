{pkgs, ...}: {
  # --- Container runtime -----------------------------------------------------
  # oci-containers defaults to podman, which doesn't understand `--gpus`.
  # You enable docker below, so tell oci-containers to actually use it.
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  # --- NVIDIA GPU passthrough (CDI) -------------------------------------------
  # `--gpus=all` / virtualisation.docker.enableNvidia no longer work on current
  # NixOS. The nvidia-container-toolkit generates a CDI spec instead, and the
  # container requests the GPU with --device=nvidia.com/gpu=all.
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.daemon.settings.features.cdi = true;

  # --- Host requirements for Steam Headless -----------------------------------
  # Provides /dev/uinput (virtual input devices for Sunshine/Steam Input).
  hardware.uinput.enable = true;

  # Persistent dirs must exist before the container starts.
  systemd.tmpfiles.rules = [
    "d /var/lib/steam-headless/home    0755 1000 1000 - -"
    "d /var/lib/steam-headless/games   0755 1000 1000 - -"
    "d /var/lib/steam-headless/sockets 0755 root root - -"
    "d /var/lib/steam-headless/sockets/.X11-unix 1777 root root - -"
    "d /var/lib/steam-headless/sockets/pulse     0755 1000 1000 - -"
  ];

  # The container uses host networking (needed for controller/input), so port
  # mappings are ignored. Open the ports in the firewall instead.
  networking.firewall.allowedTCPPorts = [8083 47984 47989 47990 48010];
  networking.firewall.allowedUDPPorts = [47998 47999 48000 48002 48010];

  virtualisation.oci-containers.containers."steam-headless" = {
    # Upstream image lives on Docker Hub under josh5/, not ghcr.io/steam-headless/.
    image = "josh5/steam-headless:latest";
    autoStart = true;

    environment = {
      TZ = "America/Los_Angeles";
      USER_LOCALES = "en_US.UTF-8 UTF-8";
      DISPLAY = ":55"; # upstream default; ":1" can clash with a host X/Xwayland display
      PUID = "1000";
      PGID = "1000";
      UMASK = "000";
      USER_PASSWORD = config.system.steam-headless-pass; # CHANGE ME: login for the web UI / container user

      MODE = "primary"; # container runs its own X server
      WEB_UI_MODE = "vnc"; # noVNC on port 8083
      PORT_NOVNC_WEB = "8083";
      ENABLE_VNC_AUDIO = "true";

      ENABLE_STEAM = "true";
      ENABLE_SUNSHINE = "true";
      SUNSHINE_USER = "sunshine";
      SUNSHINE_PASS = config.system.steam-headless-pass; # CHANGE ME

      ENABLE_EVDEV_INPUTS = "true";
      FORCE_X11_DUMMY_CONFIG = "true"; # no monitor attached -> use dummy display

      NVIDIA_DRIVER_CAPABILITIES = "all";
      NVIDIA_VISIBLE_DEVICES = "all";
    };

    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--device=/dev/dri"
      "--device=/dev/fuse"
      "--device=/dev/uinput"
      "--device-cgroup-rule=c 13:* rmw"

      "--network=host"
      "--hostname=steam-headless"
      "--add-host=steam-headless:127.0.0.1"

      "--ipc=host"
      "--shm-size=2g"
      "--ulimit=nofile=1024:524288"

      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_ADMIN"
      "--cap-add=SYS_NICE"
      "--security-opt=seccomp=unconfined"
      "--security-opt=apparmor=unconfined"
    ];

    volumes = [
      # The container user is "default" with home /home/default (not "steamuser").
      "/var/lib/steam-headless/home:/home/default:rw"
      "/var/lib/steam-headless/games:/mnt/games:rw"
      "/var/lib/steam-headless/sockets/.X11-unix:/tmp/.X11-unix:rw"
      "/var/lib/steam-headless/sockets/pulse:/tmp/pulse:rw"
    ];
  };
}
