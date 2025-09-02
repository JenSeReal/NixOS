{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.libraries.qt;
in {
  options.JenSeReal.desktop.libraries.qt = with types; {
    enable = mkEnableOption "Whether to customize qt and apply themes.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
    ];

    qt.enable = true;
  };
}
