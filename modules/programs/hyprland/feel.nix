{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnable = {
    wayland.windowManager.hyprland.settings = {
      general.layout = "dwindle";
      env = ["WLR_DRM_NO_ATOMIC,1"];
    };
  };
}
