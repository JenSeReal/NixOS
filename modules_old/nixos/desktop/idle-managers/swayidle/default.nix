{ config, lib, options, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.idle-managers.swayidle;
in
{
  options.JenSeReal.desktop.idle-managers.swayidle = {
    enable = mkEnableOption "Whether or not to add swayidle.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swayidle
    ];
  };
}
