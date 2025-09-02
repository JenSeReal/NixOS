{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.activity-monitor;
in
{
  options.${namespace}.programs.gui.activity-monitor = {
    enable = mkEnableOption "Wether to enable activity-monitor configuration.";
  };

  config = mkIf cfg.enable {
    system.defaults.ActivityMonitor = {
      ShowCategory = 100;
      IconType = 5;
      SortColumn = "CPUUsage";
      SortDirection = 1;
    };
  };
}
