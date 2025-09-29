{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bat";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.bat;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.bat = {
      enable = true;
      package = cfg.package;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ];
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
