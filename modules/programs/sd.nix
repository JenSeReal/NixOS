{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.sd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.sd;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
