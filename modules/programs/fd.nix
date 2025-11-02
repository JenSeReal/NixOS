{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.fd;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.fd = {
      enable = true;
      package = cfg.package;
    };
  };
}
