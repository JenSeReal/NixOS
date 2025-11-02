{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.delta";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.delta;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.delta = {
      enable = true;
      package = cfg.package;
    };
  };
}
