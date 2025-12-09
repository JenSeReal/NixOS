{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fluxcd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.fluxcd;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
