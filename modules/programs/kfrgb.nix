{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kfrgb";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.kfrgb;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
