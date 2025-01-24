{ config, lib, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bindl = [
          ",switch:on:Lid Switch,exec,hyprctl keyword monitor eDP-1,disable"
          ",switch:off:Lid Switch,exec,hyprctl keyword monitor eDP-1,preferred,auto,1;systemctl --user restart kanshi"
        ];
        monitor = [
          ",preferred,auto,1"
          "eDP-1,preferred,auto,1.333333,bitdepth,10"
          "desc:LG Electronics LG ULTRAWIDE 0x00017279, 2560x1080@144.00, preferred, auto,1 , bitdepth, 10"
        ];
      };
    };
  };
}
