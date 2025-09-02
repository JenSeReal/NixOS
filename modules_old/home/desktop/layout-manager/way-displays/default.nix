{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.layout-manager.way-displays;
in {
  options.JenSeReal.desktop.layout-manager.way-displays = {
    enable = mkEnableOption "way-displays.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ way-displays ];
    xdg.configFile."way-displays/cfg.yaml".source = ./cfg.yaml;
  };
}
