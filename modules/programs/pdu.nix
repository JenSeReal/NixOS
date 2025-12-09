{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pdu";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.pdu;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
