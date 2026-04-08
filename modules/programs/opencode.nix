{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.opencode";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.opencode;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.opencode = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
