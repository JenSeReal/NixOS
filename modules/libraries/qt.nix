{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "libraries.qt";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    qt.enable = true;
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
    ];

    qt.enable = true;
  };
}
