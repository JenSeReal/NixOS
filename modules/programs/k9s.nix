{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.k9s";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.k9s;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
