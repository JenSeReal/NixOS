{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.curl";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.curl;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
