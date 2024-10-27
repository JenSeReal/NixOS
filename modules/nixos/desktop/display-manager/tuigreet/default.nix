{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.display-manager.tuigreet;
in
{
  options.${namespace}.desktop.display-manager.tuigreet = {
    enable = mkBoolOpt false "Whether or not to enable tuigreet.";
    autologin = mkStrOpt "" "The user to autologin as.";
    defaultSession = mkStrOpt "sway" "The default session to start.";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${getExe pkgs.greetd.tuigreet} --time -r --cmd ${cfg.defaultSession}";
          user = "greeter";
        };
        initial_session = mkIf (cfg.autologin != "") {
          command = "${getExe pkgs.sway}";
          user = cfg.autologin;
        };
      };
    };

    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
    };
  };
}
