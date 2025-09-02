{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.launchers.raycast;
in
{
  options.JenSeReal.desktop.launchers.raycast = {
    enable = mkEnableOption "Wether to enable raycast.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "raycast" ];
    };

    launchd.user.agents.raycast = {
      command = "/Applications/Raycast.app/Contents/MacOS/Raycast";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
