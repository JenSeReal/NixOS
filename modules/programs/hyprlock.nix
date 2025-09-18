{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprlock";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.hyprlock;
    };

  home.ifEnabled = {...}: {
    programs.hyprlock.enable = true;
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
