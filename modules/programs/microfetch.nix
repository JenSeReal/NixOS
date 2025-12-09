{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.microfetch";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.microfetch;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
