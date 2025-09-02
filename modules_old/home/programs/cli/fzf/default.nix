{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.fzf;
in
{
  options.JenSeReal.programs.cli.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable { programs.fzf.enable = true; };
}
