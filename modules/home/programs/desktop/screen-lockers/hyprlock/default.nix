{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.programs.desktop.screen-lockers.hyprlock;
in {
  options.${namespace}.programs.desktop.screen-lockers.hyprlock = {
    enable = mkEnableOption "Whether or not to add hyprlock.";
  };

  config = mkIf cfg.enable {
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
}
