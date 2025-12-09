{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.rnr";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.rnr;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
