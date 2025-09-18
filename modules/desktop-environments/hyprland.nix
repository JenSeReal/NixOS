{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "desktop-environments.hyprland";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    # JenSeReal = {
    #   desktop.addons = {
    #     rofi = enabled;
    #     hyprpaper = enabled;
    #   };

    #   suites = {
    #     wlroots = enabled;
    #   };
    # };

    # home.packages = with pkgs; [
    #   hyprsunset
    #   pkgs.screen-recorder
    # ];
  };

  myconfig.ifEnabled = {myconfig, ...}: let
    mainMod = "SUPER";
    # screen-recorder = pkgs.screen-recorder;
    # screenshotter = pkgs.screenshotter;
    hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
    hyprlock = lib.getExe pkgs.hyprlock;
  in {
    audio.enable = true;
    programs = {
      hyprland = {
        enable = true;
        settings = {
          defaultPrograms = {
            terminal = myconfig.programs.wezterm.package;
            browser = myconfig.programs.firefox.package;
            launcher = myconfig.programs.yofi.package;
            explorer = myconfig.programs.nemo.package;
          };
          submaps = [
            {
              name = "🎥 (o)🖥️ (w)🪟 (a)🧭";
              trigger = "${mainMod}, R";
              actions = {
                bind = [
                  # ", o, exec, pkill -x wl-screenrec || ${screen-recorder} -o -d ${homeconfig.homeDirectory}/Pictures/Recordings"
                  # ", w, exec, pkill -x wl-screenrec || ${screen-recorder} -w -d ${homeconfig.homeDirectory}/Pictures/Recordings"
                  # ", a, exec, pkill -x wl-screenrec || ${screen-recorder} -a -d ${homeconfig.homeDirectory}/Pictures/Recordings"
                ];
              };
            }

            {
              name = "📸 (s)🖥️ (o)🖲️ (w)🪟 (a)🧭 (S)💾🖥️ (O)💾🖲️ (W)💾🪟 (A)💾🧭";
              trigger = "${mainMod}, S";
              actions = {
                bind = [
                  #", s, exec, ${screenshotter} copy screen"
                  #", o, exec, ${screenshotter} copy output"
                  #", w, exec, ${screenshotter} copy active"
                  #", a, exec, ${screenshotter} copy area"
                  # ", SHIFT s, exec, ${screenshotter} save screen ${config.home.homeDirectory}/Pictures/Screenshots"
                  # ", SHIFT o, exec, ${screenshotter} save output ${config.home.homeDirectory}/Pictures/Screenshots"
                  # ", SHIFT w, exec, ${screenshotter} save active ${config.home.homeDirectory}/Pictures/Screenshots"
                  # ", SHIFT a, exec, ${screenshotter} save area ${config.home.homeDirectory}/Pictures/Screenshots"
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
                  ", l, exec, ${hyprlock}"
                  ", e, exec, ${hyprctl} dispatch exit"
                ];
              };
            }
          ];
        };
      };
      waybar.enable = true;
      # kickoff.enable = true;
      # anyrun.enable = true;
      # way-displays.enable = true;
      firefox.enable = true;
      hyprlock.enable = true;
      yofi.enable = true;
      nemo.enable = true;
      wl-clipboard.enable = true;
    };
    services = {
      clipcat.enable = true;
      clipsync.enable = true;
      hypridle.enable = true;
      mako.enable = true;
      kanshi.enable = true;
      greetd = {
        enable = true;
        autoLogin = myconfig.constants.username;
        defaultSession = lib.getExe myconfig.programs.hyprland.package;
      };
    };
    # library.qt.enable = true;
  };

  nixos.ifEnabled = {
    # myconfig = {
    #  programs = {
    #    discord.enable = true;
    #    hyprlock.enable = true;
    #    hyprland.enable = true;
    #    waybar.enable = true;
    #    xdg.enable = true;
    #    wlogout.enable = true;
    #    wlr-randr.enable = true;
    #    wlroots.enable = true;
    #    polkit.enable = true;
    #    # bitwarden.enable = true;
    #
    #  };

    # services = {
    #   gnome-keyring.enable = true;
    # };
    # libraries.qt.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #pciutils
  #swayosd
  #grim
  #slurp
  # nwg-displays
  #];
  # };
}
