{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.launchers.kickoff;
in
{
  options.JenSeReal.desktop.launchers.kickoff = {
    enable = mkEnableOption "Kickoff.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."kickoff/config.toml".source = ./config.toml;
    home.packages = with pkgs; [
      kickoff
    ];
  };
}
