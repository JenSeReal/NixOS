{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.layout-manager.way-displays;
in
{
  options.JenSeReal.desktop.layout-manager.way-displays = with types; {
    enable = mkEnableOption "Whether or not to use way-displays.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      way-displays
    ];
    JenSeReal.user.extraGroups = [ "input" ];
  };
}
