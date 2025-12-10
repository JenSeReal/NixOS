{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pay-respects";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.pay-respects;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.pay-respects = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
