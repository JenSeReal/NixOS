{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.xwayland";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.xwayland;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
