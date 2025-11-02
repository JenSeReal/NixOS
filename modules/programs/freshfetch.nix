{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.freshfetch";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.freshfetch;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
