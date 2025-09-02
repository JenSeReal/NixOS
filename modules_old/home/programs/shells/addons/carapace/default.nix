{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.programs.shells.addons.carapace;
in
{
  options.JenSeReal.programs.shells.addons.carapace = {
    enable = mkEnableOption "Enable carapace.";
  };

  config = mkIf cfg.enable { programs.carapace.enable = true; };
}
