{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.sway";
  options = delib.singleEnableOption false;

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
