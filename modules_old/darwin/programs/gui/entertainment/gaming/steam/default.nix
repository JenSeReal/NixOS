{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.entertainment.gaming.steam;
in
{
  options.${namespace}.programs.gui.entertainment.gaming.steam = {
    enable = mkEnableOption "Wether to enable steam.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "steam" ];
    };
  };
}
