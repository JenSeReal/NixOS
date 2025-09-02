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

  cfg = config.${namespace}.services.desktop.clipboard-managers.clipse;
in
{
  options.${namespace}.services.desktop.clipboard-managers.clipse = {
    enable = mkEnableOption "clipse";
    package = mkPackageOption pkgs "clipse" { };
  };

  config = mkIf cfg.enable {
    # FIXME: enable clipse when updating to 25.05
    # services.clipse = enabled;
  };
}
