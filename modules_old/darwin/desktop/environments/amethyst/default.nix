{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.environments.amethyst;
in
{
  options.JenSeReal.desktop.environments.amethyst = {
    enable = mkEnableOption "Enable amethyst desktop environment";
  };

  config = mkIf cfg.enable { JenSeReal.desktop.window-managers.amethyst.enable = true; };
}
