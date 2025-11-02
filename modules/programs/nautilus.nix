{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nautilus";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.nautilus;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
