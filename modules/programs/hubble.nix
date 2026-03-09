{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hubble";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.hubble;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
