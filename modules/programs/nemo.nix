{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nemo";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.nemo-with-extensions;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [cfg.package nemo-preview nemo-fileroller];
    services.gvfs.enable = true;
  };
}
