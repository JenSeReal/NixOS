{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.davinci-resolve";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.davinci-resolve;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
