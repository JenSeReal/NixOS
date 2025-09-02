{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.notifications.mako;
in
{
  options.JenSeReal.desktop.notifications.mako = {
    enable = mkBoolOpt false "Whether to enable Mako.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libnotify mako ];

    systemd.user.services.mako = {
      after = [ "graphical-session.target" ];
      description = "Mako notification daemon";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";

        ExecCondition = ''
          ${getExe pkgs.bash} -c '[ -n "$WAYLAND_DISPLAY" ]'
        '';

        ExecStart = ''
          ${getExe' pkgs.mako "mako"}
        '';

        ExecReload = ''
          ${getExe' pkgs.mako "makoctl"} reload
        '';

        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
