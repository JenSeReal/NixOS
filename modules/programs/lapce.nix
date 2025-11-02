{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.lapce";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.lapce;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.lapce = {
      enable = true;
      package = cfg.package;
    };
  };
}
