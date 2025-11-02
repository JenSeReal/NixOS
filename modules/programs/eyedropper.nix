{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.eyedropper";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.eyedropper;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
