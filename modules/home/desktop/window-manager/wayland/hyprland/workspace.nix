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
          "1, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279, default: true"
          "2, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279"
          "3, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279"
          "8, monitor:desc:Microstep MSI MAG271C 0x0000011E"
          "9, monitor:desc:Microstep MSI MAG271C 0x0000011E"
          "0, monitor:desc:Microstep MSI MAG271C 0x0000011E"
        ];
      };
    };
  };
}
