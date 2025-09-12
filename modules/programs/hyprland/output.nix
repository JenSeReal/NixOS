{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled = {
    wayland.windowManager.hyprland.settings = {
      bindl = [
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor eDP-1,disable"
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor eDP-1,preferred,auto,1;systemctl --user restart kanshi"
      ];
      monitor = [
        ",preferred,auto,1"
        "eDP-1, preferred, auto, 1.333333, bitdepth, 10"
        # "desc:LG Electronics LG ULTRAWIDE 0x00017279, modeline 601.50  2560 2776 3056 3552  1080 1083 1093 1177 -hsync +vsync, auto, 1, bitdepth, 10"
      ];
    };
  };
}
