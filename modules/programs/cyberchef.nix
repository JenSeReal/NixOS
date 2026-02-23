{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.cyberchef";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.cyberchef;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
