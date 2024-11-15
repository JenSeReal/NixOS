{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.idle-manager.swayidle;

  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = cfg.lockTime * 60;

  afterLockTimeout =
    {
      timeout,
      command,
      resumeCommand ? null,
    }:
    [
      {
        timeout = lockTime + timeout;
        inherit command resumeCommand;
      }
      {
        command = "${isLocked} && ${command}";
        inherit resumeCommand timeout;
      }
    ];
in
{
  options.JenSeReal.desktop.idle-manager.swayidle = with types; {
    enable = mkEnableOption "Whether to enable swayidle in the desktop environment.";
    lockTime = mkOpt int 4 "The time in Minutes to lock the screen";
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;
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
  };
}