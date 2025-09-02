{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.portals.xdg;
in
{
  options.JenSeReal.desktop.portals.xdg = {
    enable = mkEnableOption "Whether or not to add support for xdg portal.";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
