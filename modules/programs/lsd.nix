{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.lsd";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.lsd;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.lsd = {
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
