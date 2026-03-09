{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bruno";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.bruno;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
