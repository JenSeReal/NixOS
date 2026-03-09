{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.cilium-cli";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.cilium-cli;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
