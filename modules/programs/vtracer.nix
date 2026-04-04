{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vtracer";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.vtracer;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
