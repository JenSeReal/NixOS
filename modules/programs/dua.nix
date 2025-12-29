{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dua";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.dua;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
