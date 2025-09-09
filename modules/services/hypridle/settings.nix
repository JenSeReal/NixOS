{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.hypridle";

  home.ifEnabled = {myconfig, ...}: let
    inherit (lib) getExe getExe';
    hyprctl = getExe' myconfig.programs.hyprland.package "hyprctl";
    hyprlock = getExe myconfig.programs.hyprlock.package;
    loginCtl = getExe' pkgs.systemd "loginctl";
    systemctl = getExe' pkgs.systemd "systemctl";
    brightnessctl = getExe pkgs.brightnessctl;
    pactl = "${getExe' pkgs.pulseaudio "pactl"}";
  in {
    services.hypridle.settings = {
      general = {
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        lock_cmd = "pgrep hyprlock || ${hyprlock}";
      };

      listener = [
        {
          timeout = 30;
          on-timeout = "${loginCtl} lock-session";
        }
        {
          timeout = 60;
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on && ${brightnessctl} -r";
        }
        {
          timeout = 80;
          on-timeout = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
          on-resume = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
        }
        {
          timeout = 90;
          on-timeout = "${systemctl} suspend";
        }
      ];
    };
  };
}
