{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.system.shells.addons.starship;
in
{
  options.JenSeReal.system.shells.addons.starship = {
    enable = mkEnableOption "Whether or not to use fish as a shell.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ starship ]; };
}
