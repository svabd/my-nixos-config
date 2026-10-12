{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    mySystem = {
      updateCommand = lib.mkOption {
        type = lib.types.str;
        description = "the command that should be run when rebuilding the system config";
      };
    };
  };
}
