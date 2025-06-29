{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe getExe';

  hyprctl = getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  hyprlock = getExe config.programs.hyprlock.package;
  loginCtl = getExe' pkgs.systemd "loginctl";
  systemctl = getExe' pkgs.systemd "systemctl";
  brightnessctl = getExe pkgs.brightnessctl;
  pactl = "${getExe' pkgs.pulseaudio "pactl"}";

  cfg = config.${namespace}.services.desktop.idle-managers.hypridle;
in {
  options.${namespace}.services.desktop.idle-managers.hypridle = {
    enable = lib.mkEnableOption "hypridle service";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
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
  };
}
