{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.communication.discord;
in
{
  options.JenSeReal.communication.discord = {
    enable = mkEnableOption "Steam.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
