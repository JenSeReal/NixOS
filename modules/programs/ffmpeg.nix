{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ffmpeg";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.ffmpeg-full;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
