{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.killall";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.killall;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
