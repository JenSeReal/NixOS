{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.aerospace";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.aerospace;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.aerospace = {
      enable = true;
      package = cfg.package;
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      cfg.package
    ];
  };
}
