{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.browsers.arc;
in
{
  options.${namespace}.programs.gui.browsers.arc = {
    enable = mkEnableOption "Wether to enable arc browser.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.arc-browser ]; };
}
