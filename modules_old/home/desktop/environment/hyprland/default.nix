{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    ;

  inherit (lib.${namespace}) enabled;

  mainMod = "SUPER";

  screen-recorder = getExe pkgs.${namespace}.screen-recorder;
  screenshotter = getExe pkgs.${namespace}.screenshotter;

  cfg = config.JenSeReal.desktop.environment.hyprland;
in {
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
      hyprsunset
      pkgs.${namespace}.screen-recorder
    ];

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
                  ", o, exec, pkill -x wl-screenrec || ${screen-recorder} -o -d ${config.home.homeDirectory}/Pictures/Recordings"
                  ", w, exec, pkill -x wl-screenrec || ${screen-recorder} -w -d ${config.home.homeDirectory}/Pictures/Recordings"
                  ", a, exec, pkill -x wl-screenrec || ${screen-recorder} -a -d ${config.home.homeDirectory}/Pictures/Recordings"
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
      bars.waybar = enabled;
      launchers.kickoff = enabled;
      launchers.anyrun = enabled;
      notifications.mako = enabled;
      layout-manager.kanshi = enabled;
      layout-manager.way-displays = enabled;

      # library.qt = enabled;
    };
    # JenSeReal.programs.gui.browser.firefox = enabled;
    JenSeReal.programs.gui.terminal-emulators.kitty = enabled;
    JenSeReal.programs = {
      desktop = {
        screen-lockers.hyprlock = enabled;
      };
    };
    JenSeReal.services.desktop = {
      clipboard-managers = {
        clipcatd = enabled;
        clipsync = enabled;
      };
      idle-managers.hypridle = enabled;
    };
  };
}
