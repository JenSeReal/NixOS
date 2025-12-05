{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.greetd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.greetd;
      autoLogin = allowNull (strOption null);
      defaultSession = strOption "";
      command = packageOption pkgs.tuigreet;
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.greetd = {
      inherit (cfg) enable package;
      settings = {
        default_session = {
          command = "${lib.getExe cfg.command} --time -r --cmd ${cfg.defaultSession}";
          user = "greeter";
        };
        initial_session = lib.mkIf (cfg.autoLogin != null) {
          command = "${cfg.defaultSession}";
          user = cfg.autoLogin;
        };
      };
    };
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
    };
  };
}
