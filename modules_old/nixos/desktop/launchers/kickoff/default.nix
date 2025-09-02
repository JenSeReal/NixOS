{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.launchers.kickoff;
in
{
  options.JenSeReal.desktop.launchers.kickoff = with types; {
    enable = mkEnableOption "Whether or not to use kickoff as launcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kickoff
    ];
  };
}



