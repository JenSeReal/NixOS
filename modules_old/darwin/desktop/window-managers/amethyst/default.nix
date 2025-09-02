{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.window-managers.amethyst;
in
{
  options.JenSeReal.desktop.window-managers.amethyst = {
    enable = mkEnableOption "Enable amethyst";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "amethyst" ];
    };

    JenSeReal.home.configFile."amethyst/amethyst.yml".source = ./amethyst.yml;
  };
}
