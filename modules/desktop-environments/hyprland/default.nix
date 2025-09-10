{
  delib,
  pkgs,
  lib,
  config,
  ...
}:
delib.module {
  name = "desktop-environments.hyprland";
  options = delib.singleEnableOption false;

  home.ifEnabled = {myconfig, ...}: let
    mainMod = "SUPER";

    screen-recorder = lib.getExe pkgs.screen-recorder;
    screenshotter = lib.getExe pkgs.screenshotter;
  in {
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

    myconfig.desktop = {
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
      bars.waybar.enable = true;
      launchers.kickoff.enable = true;
      launchers.anyrun.enable = true;
      notifications.mako.enable = true;
      layout-manager.kanshi.enable = true;
      layout-manager.way-displays.enable = true;

      # library.qt.enable = true;
    };
    myconfig.programs.gui.browser.firefox.enable = true;
    myconfig.programs.gui.terminal-emulators.kitty.enable = true;
    myconfig.programs = {
      desktop = {
        screen-lockers.hyprlock.enable = true;
      };
    };
    myconfig.services.desktop = {
      clipboard-managers = {
        clipcatd.enable = true;
        clipsync.enable = true;
      };
      idle-managers.hypridle.enable = true;
    };
  };

  nixos.ifEnabled = {
    myconfig = {
      communication.discord.enable = true;
      programs = {
        desktop.screen-lockers.hyprlock.enable = true;
      };
      services = {
        desktop.idle-managers.hypridle.enable = true;
      };
      desktop = {
        window-manager.wayland.hyprland.enable = true;
        display-manager.tuigreet = {
          enable = true;
          autoLogin = "jfp";
          defaultSession = lib.getExe pkgs.hyprland;
        };
        bars.waybar.enable = true;
        launchers.kickoff.enable = true;
        notifications.mako.enable = true;
        portals.xdg.enable = true;
        logout-menu.wlogout.enable = true;
        # screen-locker.swaylock-effects.enable = true;
        libraries.qt.enable = true;
        layout-manager = {
          kanshi.enable = true;
          way-displays.enable = true;
          wlr-randr.enable = true;
        };
      };
      hardware.audio.pipewire.enable = true;
      suites.wlroots.enable = true;
      security = {
        keyring.enable = true;
        polkit.enable = true;
        bitwarden.enable = true;
      };
      gui = {
        # browser.firefox.enable = true;
        file-manager.nemo.enable = true;
      };
      # themes.stylix.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pciutils
      kitty
      swayosd
      grim
      slurp
      wl-clipboard
      mako
      kanshi
      nwg-displays
    ];
  };
}
