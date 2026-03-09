{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.act";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.act;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
