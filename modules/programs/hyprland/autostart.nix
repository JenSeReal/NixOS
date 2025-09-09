{
  delib,
  pkgs,
  lib,
  config,
  ...
}:
delib.module {
  name = "programs.hyprland";

  home.ifEnable = {
    wayland.windowManager.hyprland.settings.exec-once = [
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "${lib.getExe config.programs.waybar.package}"
      "${pkgs.pyprland}/bin/pypr"
      "${pkgs.solaar}/bin/solaar -w hide"
      "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator"
    ];
  };
}
