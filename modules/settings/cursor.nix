{
  delib,
  pkgs,
  ...
}: let
  default = with pkgs; [
    phinger-cursors
    capitaine-cursors-themed
    bibata-cursors
    oreo-cursors-plus
    graphite-cursors
    JenSeReal.layan-cursors
  ];
in
  delib.module {
    name = "settings.cursor";

    options = with delib;
      moduleOptions {
        enable = boolOption false;
        additional = listOfOption package [];
      };

    nixos.ifEnabled = {cfg, ...}: {
      environment.systemPackages = default ++ cfg.additional;
    };
  }
