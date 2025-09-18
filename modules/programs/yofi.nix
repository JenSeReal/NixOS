{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.yofi";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.yofi;
    };

  home.ifEnabled = {cfg, ...}: {
    # programs.yofi = {
    #   enable = true;
    #   package = cfg.package;
    # };
    home.packages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
