{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

with lib;
with lib.JenSeReal;
with inputs;
let
  cfg = config.JenSeReal.desktop.window-manager.wayland.hyprland;
in
{
  options.JenSeReal.desktop.window-manager.wayland.hyprland = with types; {
    enable = mkEnableOption "Whether or not to use Hyprland as the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      HYPRLAND_LOG_WLR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      #NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_RENDERER = "vulkan";
      #XDG_CURRENT_DESKTOP = "Hyprland";
      #XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.dconf.enable = true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
