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

  myconfig.ifEnabled = {...}: let
    mainMod = "SUPER";
    # screen-recorder = pkgs.screen-recorder;
    # screenshotter = pkgs.screenshotter;
  in {
    programs = {
      hyprland = {
        enable = true;
        settings = {
          defaultPrograms = {
            # terminal = config.programs.wezterm.package;
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
                  ", l, exec, swaylock"
                  ", e, exec, hyprctl dispatch exit"
                ];
              };
            }
          ];
        };
      };
      # waybar.enable = true;
      # kickoff.enable = true;
      # anyrun.enable = true;
      # way-displays.enable = true;
      firefox.enable = true;
      # hyprlock.enable = true;
    };
    # services = {
    # clipcat.enable = true;
    # clipsync.enable = true;
    # hypridle.enable = true;
    # mako.enable = true;
    # kanshi.enable = true;
    # };
    # library.qt.enable = true;
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [pavucontrol];
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };
    services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
      };
    };
    # myconfig.user.extraGroups = ["audio"];

    # myconfig = {
    #  programs = {
    #    discord.enable = true;
    #    hyprlock.enable = true;
    #    hyprland.enable = true;
    #    waybar.enable = true;
    #    kickoff.enable = true;
    #    xdg.enable = true;
    #    wlogout.enable = true;
    #    way-displays.enable = true;
    #    wlr-randr.enable = true;
    #    wlroots.enable = true;
    #    polkit.enable = true;
    #    # bitwarden.enable = true;
    #    # firefox.enable = true;
    #    nemo.enable = true;
    #  };

    # services = {
    #   hypridle.enable = true;
    #   tuigreet = {
    #     enable = true;
    #     autoLogin = "jfp";
    #     defaultSession = lib.getExe pkgs.hyprland;
    #   };
    #  mako.enable = true;
    #   pipewire.enable = true;
    #   kanshi.enable = true;
    #   gnome-keyring.enable = true;
    # };
    # libraries.qt.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #pciutils
  #swayosd
  #grim
  #slurp
  #wl-clipboard
  # nwg-displays
  #];
  # };
}
