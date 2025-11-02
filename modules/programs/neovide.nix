{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.neovide";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.neovide;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.neovide = {
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
