{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.intellij";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.jetbrains.idea-community;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
