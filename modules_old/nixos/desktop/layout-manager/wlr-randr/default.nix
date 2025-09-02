{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.layout-manager.wlr-randr;
in
{
  options.JenSeReal.desktop.layout-manager.wlr-randr = with types; {
    enable = mkEnableOption "Whether or not to use wlr-randr.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wlr-randr
    ];
    JenSeReal.user.extraGroups = [ "input" ];
  };
}
