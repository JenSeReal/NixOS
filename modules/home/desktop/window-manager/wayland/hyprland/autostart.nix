{ config, lib, pkgs, ... }:
with lib;
let cfg = config.JenSeReal.desktop.window-managers.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &"
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
          "waybar"
          "command -v ${
            getExe pkgs.cliphist
          } && wl-paste --type text --watch cliphist store"
          "command -v ${
            getExe pkgs.cliphist
          } && wl-paste --type image --watch cliphist store"
        ];
      };
    };
  };
}
