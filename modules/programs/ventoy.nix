{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ventoy";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.ventoy-bin-full;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
