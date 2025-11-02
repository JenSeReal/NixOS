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
    services.vscode-server.enable = true;
    programs.vscode = {
      enable = true;
      package = cfg.package;
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
