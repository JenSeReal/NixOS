{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.gui.browser.firefox;
in
{
  options.JenSeReal.gui.browser.firefox = {
    enable = mkEnableOption "Firefox.";
  };
  config = mkIf cfg.enable { programs.firefox.enable = true; };
}
