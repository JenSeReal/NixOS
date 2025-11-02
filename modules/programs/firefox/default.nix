{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.firefox";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.firefox-bin;
      extraConfig = strOption "";
      settings = attrsOption {};
      gpuAcceleration = boolOption false;
      hardwareDecoding = boolOption false;
      userChrome = strOption "";
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [
      cfg.package
    ];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.firefox = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    programs.firefox = {
      enable = true;
      package = cfg.package;
    };
  };
}
