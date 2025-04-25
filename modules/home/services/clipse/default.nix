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

  cfg = config.${namespace}.services.clipse;
in
{
  options.${namespace}.services.clipse = {
    enable = mkEnableOption "clipse";
    package = mkPackageOption pkgs "clipse" { };
  };

  config = mkIf cfg.enable {
    # FIXME: enable clipse when updating to 25.05
    # services.clipse = enabled;
  };
}
