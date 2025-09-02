{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.thefuck;
in
{
  options.JenSeReal.programs.cli.thefuck = {
    enable = mkEnableOption "thefuck";
  };

  config = mkIf cfg.enable { programs.thefuck.enable = true; };
}
