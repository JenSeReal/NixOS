{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.xcp";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.xcp;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
