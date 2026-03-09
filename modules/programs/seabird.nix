{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.seabird";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.seabird;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
