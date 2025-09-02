{
  delib,
  moduleSystem,
  config,
  pkgs,
  homeManagerUser,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in
  delib.module {
    name = "home";

    nixos.always = {
      environment.systemPackages = [pkgs.home-manager];
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "home_manager_backup";
      };
    };

    home.always = {myconfig, ...}: let
      inherit (myconfig.constants) username;
    in {
      programs.home-manager.enable = true;
      home = {
        inherit username;
        homeDirectory =
          if isDarwin
          then "/Users/${username}"
          else "/home/${username}";
        stateVersion = "25.05";
      };
    };

    myconfig.always.args.shared.homeconfig =
      if moduleSystem == "home"
      then config
      else config.home-manager.users.${homeManagerUser};
  }
