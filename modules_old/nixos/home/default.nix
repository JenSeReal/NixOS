{
  options,
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) types mkAliasDefinitions;
  inherit (lib.${namespace}) mkOpt;
  inherit (types) attrs;
in
{
  options.JenSeReal.home = {
    file = mkOpt attrs { } "A set of files to be managed by home-manager's `home.file`.";
    configFile = mkOpt attrs { } "A set of files to be managed by home-manager's `xdg.configFile`.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    JenSeReal.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.JenSeReal.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.JenSeReal.home.configFile;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      backupFileExtension = "hm.old";

      users.${config.JenSeReal.user.name} = mkAliasDefinitions options.JenSeReal.home.extraOptions;
    };
  };
}
