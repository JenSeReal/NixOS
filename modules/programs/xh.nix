{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.xh";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.xh;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
