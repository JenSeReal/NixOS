{ config, lib, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        general = {
          # allow_tearing = true;
          layout = "dwindle";
        };

        env = [ "WLR_DRM_NO_ATOMIC,1" ];
      };
    };
  };
}
