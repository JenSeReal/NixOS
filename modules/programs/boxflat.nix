{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.boxflat";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.boxflat;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      cfg.package
    ];
    services.udev.packages = [cfg.package];
  };
}
