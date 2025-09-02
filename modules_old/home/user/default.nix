{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkDefault
    ;
  inherit (lib.types) nullOr str;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;

  is-darwin = pkgs.stdenv.isDarwin;

  home-directory =
    if cfg.name == null then
      null
    else if is-darwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";
in
{
  options.${namespace}.user = {
    enable = mkEnableOption "Whether to configure the user account.";
    name = mkOpt (nullOr str) config.${namespace}.user.name "The user account.";

    fullName = mkOpt str "Jens Plüddemann" "The full name of the user.";
    email = mkOpt str "jens@plueddemann.de" "The email of the user.";

    home = mkOpt (nullOr str) home-directory "The user's home directory.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "JenSeReal.user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "JenSeReal.user.home must be set";
        }
      ];

      home = {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;
      };
    }
  ]);
}
