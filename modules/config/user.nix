{delib, ...}:
delib.module {
  name = "user";
  options = with delib;
    moduleOptions {
      extraGroups = listOfOption str [];
    };

  nixos.always = {
    myconfig,
    cfg,
    ...
  }: let
    inherit (myconfig.constants) username;
  in {
    users = {
      groups.${username} = {};

      users.${username} = {
        isNormalUser = true;
        initialPassword = username;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
      };
    };
  };

  darwin.always = {myconfig, ...}: let
    inherit (myconfig.constants) username;
  in {
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };
  };
}
