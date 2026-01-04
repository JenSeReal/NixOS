{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.mpv";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.mpv;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
