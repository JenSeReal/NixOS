{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.btop";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.btop;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.btop = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
