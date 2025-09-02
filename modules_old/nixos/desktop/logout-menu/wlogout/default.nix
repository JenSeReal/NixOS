{ config, lib, options, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.logout-menu.wlogout;
in
{
  options.JenSeReal.desktop.logout-menu.wlogout = {
    enable = mkEnableOption "Whether or not to add wlogout.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wlogout
    ];
  };
}
