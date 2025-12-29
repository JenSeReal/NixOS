{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprlock";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.hyprlock;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.hyprlock = {
      enable = true;
      package = cfg.package;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
          text_trim = true;
        };
        background = {
          path = lib.mkForce "screenshot";
          blur_passes = 2;
        };
        auth."fingerprint:enabled" = true;
      };
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
