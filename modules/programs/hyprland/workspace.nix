{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled = {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "1, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279, default:true"
        "2, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279"
        "3, monitor:desc:LG Electronics LG ULTRAWIDE 0x00017279"
        "8, monitor:desc:Microstep MSI MAG271C 0x0000011E, default:true"
        "9, monitor:desc:Microstep MSI MAG271C 0x0000011E"
        "10, monitor:desc:Microstep MSI MAG271C 0x0000011E"
      ];
    };
  };
}
