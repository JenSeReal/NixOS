{
  delib,
  pkgs,
  lib,
  config,
  ...
}:
delib.module {
  name = "programs.sway";
  options = delib.singleEnableOption false;

  home.ifEnabled = let
    modifier = config.wayland.windowManager.sway.config.modifier;

    clamshell = pkgs.writeShellScript "clamshell.sh" ''
      # Set your laptop screen name
      set $laptop_screen 'eDP-1'

      # Clamshell mode or lock & sleep
      # This is a if/else statement: [ outputs_count == 1 ] && true || false
      bindswitch --reload --locked lid:on exec '[ $(swaymsg -t get_outputs | grep name | wc -l) == 1 ] && (${lib.getExe' pkgs.systemd "systemctl"} suspend -f) || (swaymsg output $laptop_screen disable)'

      bindswitch --reload --locked lid:off output $laptop_screen enable
    '';
  in {
    home.sessionVariables = {
      GSK_RENDERER = "gl";
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${lib.getExe config.programs.wezterm.package}";
        menu = "${lib.getExe pkgs.yofi} binapps";
        bars = [{command = "${lib.getExe pkgs.waybar}";}];
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
            xkb_numlock = "enabled";
          };

          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };
        startup = [
          {
            command = "${lib.getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator";
            always = true;
          }
          {
            command = "${clamshell.outPath}";
            always = true;
          }
        ];
        keybindings = lib.mkOptionDefault {
          "${modifier}+l" = "exec ${lib.getExe config.programs.swaylock.package}";
          "${modifier}+Shift+c" = "reload; exec ${lib.getExe' pkgs.systemd "systemctl"} --user restart kanshi";
        };
        window.titlebar = false;
        window.hideEdgeBorders = "smart";
        window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "^firefox$";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              class = "^Firefox$";
            };
          }
          {
            command = "floating enable";
            criteria = {
              class = "steam";
            };
          }
          {
            command = "floating disable";
            criteria = {
              class = "steam";
              title = "^Steam$";
            };
          }
        ];
        assigns = {
          "1" = [
            {title = "^(.*(Twitch|TNTdrama|YouTube|Bally Sports|Video Entertainment|Plex)).*(Firefox).*$";}
          ];
          "2" = [
            {app_id = "^Code$";}
            {app_id = "^neovide$";}
            {app_id = "^GitHub Desktop$";}
            {app_id = "^GitKraken$";}
          ];
          "3" = [];
          "4" = [
            {class = "^steam_app_.*$";}
          ];
          "5" = [
            {app_id = "^thunderbird$";}
          ];
          "6" = [
            {app_id = "^mpv|vlc|VLC|mpdevil$";}
            {app_id = "^Spotify$";}
            {title = "^Spotify$";}
            {title = "^Spotify Free$";}
            {class = "^elisa$";}
          ];
          "7" = [];
          "8" = [{app_id = "^io.github.lawstorant.boxflat$";}];
          "9" = [
            {app_id = "^(discord|WebCord)$";}
            {app_id = "^Element$";}
          ];
          "10" = [
            {class = "^steam$";}
            {app_id = "^net.lutris.Lutris$";}
          ];
        };

        floating = {
          criteria = [
            # Float specific applications
            {class = "Rofi";}
            {class = "viewnior";}
            {class = "feh";}
            {class = "wlogout";}
            {class = "file_progress";}
            {class = "confirm";}
            {class = "dialog";}
            {class = "download";}
            {class = "notification";}
            {class = "error";}
            {class = "splash";}
            {class = "confirmreset";}
            {class = "org.kde.polkit-kde-authentication-agent-1";}
            {class = "wdisplays";}
            {class = "blueman-manager";}
            {class = "nm-connection-editor";}
            {title = "^(floatterm)$";}
          ];
        };
      };
    };
  };

  nixos.ifEnabled = {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swayidle
        swaylock
        swaylock-fancy
        xwayland
        libinput
        playerctl
        brightnessctl
        glib
        gtk3.out
        gtk4
        gnome-control-center
        tofi
        kickoff
        anyrun
        yofi
        walker
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export GSK_RENDERER=gl
      '';
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
      (writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${bash}/bin/bash

          # Import environment variables from the login manager
          systemctl --user import-environment

          # Start Sway
          exec systemctl --user start sway.service
        '';
      })
    ];

    # configuring sway itself (assmung a display manager starts it)
    systemd.user.targets.sway-session = {
      description = "sway compositor session";
      documentation = ["man:systemd.special(7)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = ["man:sway(5)"];
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
        '';
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services.libinput.enable = true;
    programs.dconf.enable = true;
    services.dbus.enable = true;
  };
}
