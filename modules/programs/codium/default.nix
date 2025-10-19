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
      package = pkgs.unstable.vscodium;
    };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  home.ifEnabled = {cfg, ...}: {
    imports = [inputs.vscode-server.homeModules.default];

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
