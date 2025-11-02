{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.onlyoffice";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.onlyoffice-bin;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
