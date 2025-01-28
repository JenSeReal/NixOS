{ config, lib, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        workspace = [
          "1, monitor:DP-11, default:true"
          "2, monitor:DP-11"
          "3, monitor:DP-11"
          "8, monitor:DP-9, default:true"
          "9, monitor:DP-9"
          "0, monitor:DP-9"
        ];
      };
    };
  };
}
