{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.rip";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.rip2;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
