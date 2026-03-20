{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.osc";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.osc;
    };

  nixos.ifEnabled = {cfg, ...}: let
    xclip-wrapper = pkgs.writeShellScriptBin "xclip" ''
      exec ${cfg.package}/bin/osc copy
    '';
    xsel-wrapper = pkgs.writeShellScriptBin "xsel" ''
      exec ${cfg.package}/bin/osc copy
    '';
  in {
    environment.systemPackages = [
      cfg.package
      xclip-wrapper
      xsel-wrapper
    ];
  };
}
