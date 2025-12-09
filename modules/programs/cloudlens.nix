{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.cloudlens";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.cloudlens;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
