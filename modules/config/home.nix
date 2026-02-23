{
  delib,
  moduleSystem,
  config,
  pkgs,
  homeManagerUser,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in
  delib.module {
    name = "home";
    options = with delib;
      moduleOptions {
        file = attrsOfOption str {};
        configFile = attrsOfOption str {};
        extraOptions = attrsOfOption str {};
      };

    darwin.always = {
      home-manager = {
        backupFileExtension = "hm.old";

        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };

    nixos.always = {
      environment.systemPackages = [pkgs.home-manager];
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "hm.old";
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
        stateVersion = lib.mkDefault "25.11";
      };
    };

    myconfig.always.args.shared.homeconfig =
      if moduleSystem == "home"
      then config
      else config.home-manager.users.${homeManagerUser};
  }
