{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    ;
  inherit (lib.${namespace}) enabled;

  cfg = config.JenSeReal.services.clipse;
in
{
  options.JenSeReal.services.clipse = {
    enable = mkEnableOption "clipse";
    package = mkPackageOption pkgs "clipse" { };
  };

  config = mkIf cfg.enable {
    services.clipse = enabled;
  };
}
