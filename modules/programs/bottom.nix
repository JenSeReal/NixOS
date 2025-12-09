{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bottom";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.bottom;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
