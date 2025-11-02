{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kdenlive";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.kdePackages.kdenlive;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
