{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zed";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.zed-editor;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    programs.zed-editor = {
      enable = true;
      package = cfg.package;
      installRemoteServer = true;
      mutableUserSettings = false;
      mutableUserKeymaps = false;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
