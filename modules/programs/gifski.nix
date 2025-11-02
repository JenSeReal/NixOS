{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.gifski";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.gifski;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
