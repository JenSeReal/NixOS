{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.procs";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.procs;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
