{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    ;

  mainMod = "SUPER";

  screen-recorder = getExe pkgs.${namespace}.screen-recorder;
  toggle = getExe pkgs.${namespace}.toggle;
  screenshotter = getExe pkgs.${namespace}.screenshotter;

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
      xwaylandvideobridge
      wl-screenrec
      skim
    ];

    services.kanshi.enable = true;
    JenSeReal.desktop = {
      window-managers.hyprland = {
        enable = true;
        settings = {
          defaultPrograms = {
            terminal = config.programs.wezterm.package;
          };
          submaps = [
            {
              name = "🎥 (o)🖥️ (w)🪟 (a)🧭";
              trigger = "${mainMod}, R";
              actions = {
                bind = [
                  ", o, exec, ${toggle} ${screen-recorder} -o -d ${config.home.homeDirectory}/Pictures/Recordings"
                  ", w, exec, ${toggle} ${screen-recorder} -w -d ${config.home.homeDirectory}/Pictures/Recordings"
                  ", a, exec, ${toggle} ${screen-recorder} -a -d ${config.home.homeDirectory}/Pictures/Recordings"
                ];
              };
            }

            {
              name = "📸 (s)🖥️ (o)🖲️ (w)🪟 (a)🧭 (S)💾🖥️ (O)💾🖲️ (W)💾🪟 (A)💾🧭";
              trigger = "${mainMod}, S";
              actions = {
                bind = [
                  ", s, exec, ${screenshotter} copy screen"
                  ", o, exec, ${screenshotter} copy output"
                  ", w, exec, ${screenshotter} copy active"
                  ", a, exec, ${screenshotter} copy area"
                  ", SHIFT s, exec, ${screenshotter} save screen ${config.home.homeDirectory}/Pictures/Screenshots"
                  ", SHIFT o, exec, ${screenshotter} save output ${config.home.homeDirectory}/Pictures/Screenshots"
                  ", SHIFT w, exec, ${screenshotter} save active ${config.home.homeDirectory}/Pictures/Screenshots"
                  ", SHIFT a, exec, ${screenshotter} save area ${config.home.homeDirectory}/Pictures/Screenshots"
                ];
              };
            }

            {
              name = "🔌 (p)⏻ (r)🔁 (s)💤 (l)🔒 (e)🚪";
              trigger = "${mainMod}, Q";
              actions = {
                bind = [
                  ", p, exec, systemctl poweroff"
                  ", r, exec, systemctl reboot"
                  ", s, exec, systemctl suspend"
                  ", l, exec, swaylock"
                  ", e, exec, hyprctl dispatch exit"
                ];
              };
            }
          ];
        };
      };
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
    JenSeReal.programs = {
      clipcat-menu = {
        enable = true;
        settings.finder = "skim";
      };
      clipcatctl.enable = true;
    };
    JenSeReal.services = {
      clipcatd.enable = true;
      clipsync.enable = true;
    };

  };
}
