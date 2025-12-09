{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.opentofu";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.opentofu;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
