{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.yazi";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.yazi;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.yazi = {
      enable = true;
      package = cfg.package;
    };
  };
}
