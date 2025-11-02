{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dust";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.dust;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
