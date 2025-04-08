{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.citrix;
in
{
  options.${namespace}.programs.gui.citrix = {
    enable = mkEnableOption "Wether to enable citrix.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "citrix-workspace" ];
    };
  };
}
