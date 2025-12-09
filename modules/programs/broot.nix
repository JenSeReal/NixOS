{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.broot";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.broot;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.broot = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
