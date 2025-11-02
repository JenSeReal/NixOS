{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.helix";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.helix;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.helix = {
      enable = true;
      package = cfg.package;
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
