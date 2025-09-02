{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.bat;
in
{
  options.JenSeReal.programs.cli.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable { programs.bat.enable = true; };
}
