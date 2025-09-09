{
  delib,
  pkgs,
  config,
  lib,
  ...
}:
delib.module {
  name = "services.swayidle";
  options = delib.singleEnableOption false;

  home.ifEnabled = {cfg, ...}: let
    swaylock = "${config.programs.swaylock.package}/bin/swaylock";
    pgrep = "${pkgs.procps}/bin/pgrep";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
    hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
    swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

    isLocked = "${pgrep} -x ${swaylock}";
    lockTime = cfg.lockTime * 60;

    afterLockTimeout = {
      timeout,
      command,
      resumeCommand ? null,
    }: [
      {
        timeout = lockTime + timeout;
        inherit command resumeCommand;
      }
      {
        command = "${isLocked} && ${command}";
        inherit resumeCommand timeout;
      }
    ];
  in {
    services.swayidle = {
      systemdTarget = "graphical-session.target";
      timeouts =
        # Lock screen
        [
          {
            timeout = lockTime;
            command = "${swaylock} --daemonize";
          }
        ]
        ++
        # Mute mic
        (afterLockTimeout {
          timeout = 10;
          command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
          resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
        })
        ++
        # Turn off RGB
        # (lib.optionals config.services.rgbdaemon.enable (afterLockTimeout {
        #   timeout = 20;
        #   command = "systemctl --user stop rgbdaemon";
        #   resumeCommand = "systemctl --user start rgbdaemon";
        # })) ++
        # Turn off displays (hyprland)
        (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
          timeout = 40;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }))
        ++
        # Turn off displays (sway)
        (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
          timeout = 40;
          command = "${swaymsg} 'output * dpms off'";
          resumeCommand = "${swaymsg} 'output * dpms on'";
        }));
    };

    # resumeCommand = "${getExe pkgs.wlopm} --on \*";
    # services.swayidle = {
    #   enable = true;

    #   systemdTarget = "sway-session.target";
    #   events = [
    #     {
    #       event = "before-sleep";
    #       command = "${getExe config.programs.swaylock.package} -fF";
    #     }
    #     {
    #       event = "after-resume";
    #       command = "${getExe pkgs.wlopm} --on \*";
    #     }
    #     {
    #       event = "lock";
    #       command = "${getExe config.programs.swaylock.package} -fF";
    #     }
    #   ];
    #   timeouts = [
    #     {
    #       timeout = 30;
    #       command = "${getExe config.programs.swaylock.package} -fF";
    #     }
    #     {
    #       timeout = 60;
    #       command = "${getExe' pkgs.systemd "systemctl"} suspend -f";
    #       inherit resumeCommand;
    #     }
    #   ];
    # };
  };
}
