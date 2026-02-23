{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.helmfile";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.helmfile;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
