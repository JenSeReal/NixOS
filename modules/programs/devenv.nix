{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.devenv";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.devenv;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
