{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.starship";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.starship;
    };

  darwin.ifEnabled = {cfg, ...}: {environment.systemPackages = [cfg.package];};
  nixos.ifEnabled = {cfg, ...}: {environment.systemPackages = [cfg.package];};

  home.ifEnabled = {cfg, ...}: {
    programs.starship = {
      enable = true;
      package = cfg.package;
    };
  };
}
