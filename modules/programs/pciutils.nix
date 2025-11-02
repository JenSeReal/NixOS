{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pciutils";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.pciutils;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
