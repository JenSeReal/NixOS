{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.layout-manager.kanshi;
in
{
  options.JenSeReal.desktop.layout-manager.kanshi = with types; {
    enable = mkEnableOption "Whether or not to use kanshi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kanshi
    ];
    JenSeReal.user.extraGroups = [ "input" ];
  };
}
