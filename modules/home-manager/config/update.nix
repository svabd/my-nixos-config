{
  config,
  lib,
  ...
}: {
  options = {
    mySystem = {
      updateScript = lib.mkOption {
        type = lib.types.str;
        default = "sudo zsh /home/sv_abd/my-nixos-config/bash/system.sh";
        description = "The primary username for this machine.";
      };
    };
  };
}
