{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.hyprland;
      extraConfig = strOption "";
    };

  home.ifEnabled = {cfg, ...}: {
    programs.waybar.systemd.target = "hyprland-session.target";

    wayland.windowManager.hyprland = {
      inherit (cfg) enable package;

      extraConfig = ''
        env = XDG_DATA_DIRS,'${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}':$XDG_DATA_DIRS
        env = HYPRLAND_TRACE,1

        ${cfg.extraConfig}
      '';

      settings = {
        exec = [''notify-send -i ~/.face -u normal -t 5000 "Hello $(whoami)"''];
        "ecosystem:no_update_news" = true;
        "ecosystem:no_donation_nag" = true;
      };

      systemd.variables = ["--all"];
    };
  };

  nixos.ifEnabled = {
    security.pam.services.hyprland.enableGnomeKeyring = true;

    environment.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      HYPRLAND_LOG_WLR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_RENDERER = "vulkan";
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
        common.default = ["gtk"];
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };
}
