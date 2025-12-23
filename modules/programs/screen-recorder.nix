{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.screen-recorder";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.screen-recorder;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
