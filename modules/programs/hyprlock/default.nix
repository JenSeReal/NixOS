{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprlock";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          grace = 5;
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

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [hyprlock];
  };
}
