{
  lib,
  config,
  namespace,
  ...
}:

let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;
  inherit (types) str;
  cfg = config.JenSeReal.system.time;
in
{
  options.JenSeReal.system.time = {
    enable = mkEnableOption "Whether or not to use the variables set.";
    timeZone = mkOpt str "Europe/Berlin" "The time zone to use";
  };

  config = mkIf cfg.enable { time.timeZone = cfg.timeZone; };
}
