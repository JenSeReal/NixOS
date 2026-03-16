{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.codium";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.vscodium;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.always = {
    imports = [inputs.vscode-server.homeModules.default];
  };
  home.ifEnabled = {cfg, ...}: {
    programs.vscode = {
      enable = true;
      package = cfg.package;
    };
    services.vscode-server.enable = true;
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
