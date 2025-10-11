{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.DataLink";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.DataLink;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
