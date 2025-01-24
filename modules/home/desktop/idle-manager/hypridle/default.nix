{
  config,
  lib,
  ...
}:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.idle-manager.hypridle;

  hyprctl = getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  swaylock = getExe config.programs.swaylock.package;

in
{
  options.JenSeReal.desktop.idle-manager.hypridle = with types; {
    enable = mkEnableOption "Whether to enable hypridle in the desktop environment.";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          before_sleep_cmd = "pidof swaylock || ${swaylock}"; # Lock before suspend.
          after_sleep_cmd = "${hyprctl} dispatch dpms on"; # Avoid having to press a key twice to turn on the display.
        };

        listener = [
          # Dim screen.
          {
            timeout = 30;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }

          # Lock screen.
          {
            timeout = 60;
            on-timeout = "pidof swaylock || ${swaylock}";
          }

          # Turn off screen.
          {
            timeout = 90;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }

          # Suspend.
          {
            timeout = 120;
            on-timeout = "pidof swaylock || ${swaylock} & systemctl suspend";
          }
        ];
      };
    };
  };
}
