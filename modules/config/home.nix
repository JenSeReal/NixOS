{
  delib,
  moduleSystem,
  config,
  pkgs,
  homeManagerUser,
  lib,
  options,
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

    darwin.always = {myconfig, ...}: {
      myconfig.home.extraOptions = {
        home.file = lib.mkAliasDefinitions options.home.file;
        xdg.enable = true;
        xdg.configFile = lib.mkAliasDefinitions options.home.configFile;
      };

      users.${myconfig.constants.username} = lib.mkAliasDefinitions options.home.extraOptions;

      home-manager = {
        backupFileExtension = "hm.old";

        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };

    nixos.always = {...}: {
      environment.systemPackages = [pkgs.home-manager];
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "hm.old";

        # users.${myconfig.constants.username} = lib.mkAliasDefinitions options.home.extraOptions;
      };

      # home.stateVersion = config.system.stateVersion;
      # home.extraOptions = {
      # home.file = lib.mkAliasDefinitions options.home.file;
      # xdg.enable = true;
      # xdg.configFile = lib.mkAliasDefinitions options.home.configFile;
      # };
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
