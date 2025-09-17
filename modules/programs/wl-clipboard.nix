{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wl-clipboard";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.wl-clipboard;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
