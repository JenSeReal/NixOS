{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled = {
    wayland.windowManager.hyprland.settings = {
      general.layout = "dwindle";
      env = ["WLR_DRM_NO_ATOMIC,1"];
    };
  };
}
