{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;
  cfg = config.JenSeReal.system.power-management;
in
{
  options.JenSeReal.system.power-management = {
    enable = mkEnableOption "Whether or not to use powermanagement.";
  };

  config = mkIf cfg.enable {
    services.thermald = enabled;
    # services.auto-cpufreq = enabled;
    powerManagement = {
      enable = true;
    };
    # hardware.system76.power-daemon = enabled;
  };
}
