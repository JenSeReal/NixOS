{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.library.qt;
in {
  options.JenSeReal.desktop.library.qt = { enable = mkEnableOption "QT."; };
  config = mkIf cfg.enable { qt = { enable = true; }; };
}
