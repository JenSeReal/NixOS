{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fzf";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.delta;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.fzf = {
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
