{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.system.shells.fish;
in
{
  options.JenSeReal.system.shells.fish = {
    enable = mkEnableOption "Whether or not to use fish as a shell.";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    environment.shells = with pkgs; [ fish ];
  };
}
