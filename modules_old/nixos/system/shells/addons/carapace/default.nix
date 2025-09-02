{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.system.shells.addons.carapace;
in
{
  options.JenSeReal.system.shells.addons.carapace = {
    enable = mkEnableOption "Whether or not to use carapace completion.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ carapace ]; };
}
