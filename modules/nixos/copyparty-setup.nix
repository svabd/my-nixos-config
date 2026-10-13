{inputs, lib, ...}: let
users = {
  "sv_abd" = {
    is-admin = true;
  };
  "sv_zed" = {
    is-admin = false;
    max-size = "2g";
  };
};
in {
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

  services.copyparty = {
    enable = true;

    settings = {
      i = "0.0.0.0";      
      p = [ 3939 ];
      
    };

    accounts = let
    a = builtins.attrNames users;
    b = builtins.map (h: {"${h}" = {passwordFile = "/run/keys/copyparty/${h}.txt";};}) a;
    c = lib.mergeAttrsList b;
    in c;

    # Define your shared directories (volumes)
    volumes = let
      a = builtins.attrNames users;
      b = builtins.map (user: {"/${user}" = {path = "/srv/copyparty/data/${user}"; access = {"rwmd" = user; "A" = builtins.filter (u: users."${u}".is-admin == true) a;};};}) a;
      c = lib.mergeAttrsList b;
    in c // {"/" = {path = "/srv/copyparty/data/"; access = {"A" = builtins.filter (u: users."${u}".is-admin == true) a;}; flags = {"e2dsa" = true; "e2ts" = true; "z" = true;};};};
  };
}
