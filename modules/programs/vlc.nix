{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vlc";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.vlc;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
