{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bottles";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.bottles;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      cfg.package
      wineWowPackages.waylandFull
      winetricks
    ];
  };
}
