{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.lutris";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      extraLibraries = listOfOption package [];
      extraPackages = listOfOption package [];
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      wineWowPackages.waylandFull
      winetricks
      protontricks
      protonup-qt
      vulkan-tools
      (lutris.override {
        extraPkgs = pkgs:
          cfg.extraPackages
          ++ [
            wineWowPackages.waylandFull
            winetricks
            protontricks
          ];
        extraLibraries = pkgs: cfg.extraLibraries;
      })
    ];
  };
}
