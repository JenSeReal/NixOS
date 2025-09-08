{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.tuigreet";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      autoLogin = strOption "";
      defaultSession = strOption "sway";
    };

  nixos.ifEnabled = {cfg, ...}: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --time -r --cmd ${cfg.defaultSession}";
          user = "greeter";
        };
        initial_session = lib.mkIf (cfg.autoLogin != "") {
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
