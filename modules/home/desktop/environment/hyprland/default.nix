{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.environment.hyprland;
in
{
  options.JenSeReal.desktop.environment.hyprland = {
    enable = mkEnableOption "Hyprland.";
  };

  config = mkIf cfg.enable {
    # JenSeReal = {
    #   desktop.addons = {
    #     rofi = enabled;
    #     hyprpaper = enabled;
    #   };

    #   suites = {
    #     wlroots = enabled;
    #   };
    # };

    home.packages = with pkgs; [
      grim
      hyprsunset
      pkgs.${namespace}.screen-recorder
      slurp
      xclip
      clipse
      xwaylandvideobridge
      wl-screenrec
      clipcat
      clipmenu
    ];

    services.kanshi.enable = true;
    JenSeReal.desktop = {
      window-managers.hyprland.enable = true;
      bars.waybar.enable = true;
      launchers.kickoff.enable = true;
      launchers.anyrun.enable = true;
      notifications.mako.enable = true;
      idle-manager.hypridle.enable = true;
      screen-locker.swaylock-effects.enable = true;
      layout-manager.kanshi.enable = true;
      layout-manager.way-displays.enable = true;
      # library.qt.enable = true;
    };
    # JenSeReal.programs.gui.browser.firefox.enable = true;
    JenSeReal.programs.gui.terminal-emulators.kitty.enable = true;
    JenSeReal.services = {
      clipmenu.enable = true;
      clipcat.enable = true;
    };

  };
}
