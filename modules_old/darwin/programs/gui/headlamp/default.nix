{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.headlamp;
in
{
  options.${namespace}.programs.gui.headlamp = {
    enable = mkEnableOption "Wether to enable headlamp.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "headlamp" ];
    };
  };
}
