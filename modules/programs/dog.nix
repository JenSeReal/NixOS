{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dog";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.dogdns;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
