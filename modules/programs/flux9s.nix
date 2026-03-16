{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.flux9s";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.flux9s;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
