{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.ripgrep;
in
{
  options.JenSeReal.programs.cli.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable { programs.ripgrep.enable = true; };
}
