{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.gimp";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.gimp-with-plugins;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  darwin.ifEnabled = {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["gimp"];
    };
  };
}
