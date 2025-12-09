{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zellij";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.zellij;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.zellij = {
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
