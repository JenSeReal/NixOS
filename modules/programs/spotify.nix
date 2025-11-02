{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.spotify";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.spotify;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
