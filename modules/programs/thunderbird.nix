{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.thunderbird";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.thunderbird-latest-bin;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
