{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.difftastic";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.difftastic;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
