{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.eza;
in
{
  options.JenSeReal.programs.cli.eza = {
    enable = mkEnableOption "eza";
  };

  config = mkIf cfg.enable { programs.eza.enable = true; };
}
