{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.zoxide;
in
{
  options.JenSeReal.programs.cli.zoxide = {
    enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable { programs.zoxide.enable = true; };
}
