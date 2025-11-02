{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zoxide";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.zoxide;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.zoxide = {
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
