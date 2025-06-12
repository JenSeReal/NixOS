{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = {
    name = mkOpt types.str "jfp" "The user account.";
    email = mkOpt types.str "jens.plueddemann@cgi.com" "The email of the user.";
    fullName = mkOpt types.str "Jens Plüddemann" "The full name of the user.";
    uid = mkOpt (types.nullOr types.int) 502 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = {
      uid = mkIf (cfg.uid != null) cfg.uid;
      shell = pkgs.zsh;
    };
  };
}
