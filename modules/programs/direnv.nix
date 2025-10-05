{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.direnv";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.direnv;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.direnv = {
      enable = true;
      package = cfg.package;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      cfg.package
      nix-direnv
    ];
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      cfg.package
      nix-direnv
    ];
  };
}
