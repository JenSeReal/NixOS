{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.crossplane";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.crossplane-cli;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
