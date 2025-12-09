{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.macchina";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.macchina;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
