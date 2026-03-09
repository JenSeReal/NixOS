{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.inkscape";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.inkscape-with-extensions;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
