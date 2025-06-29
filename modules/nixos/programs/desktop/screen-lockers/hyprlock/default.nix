{
  config,
  lib,
  pkgs,
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
    environment.systemPackages = with pkgs; [hyprlock];
  };
}
