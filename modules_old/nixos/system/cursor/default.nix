{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) listOf package;
  inherit (lib.${namespace}) mkOpt;
  cfg = config.JenSeReal.system.cursor;

  default = with pkgs; [
    phinger-cursors
    capitaine-cursors-themed
    bibata-cursors
    oreo-cursors-plus
    graphite-cursors
    JenSeReal.layan-cursors
  ];

in
{
  options.JenSeReal.system.cursor = {
    enable = mkEnableOption "Whether or not to enable additional cursors.";
    additional = mkOpt (listOf package) [ ] "Custom cursor packages to install.";
  };

  config = mkIf cfg.enable { environment.systemPackages = default ++ cfg.additional; };
}
