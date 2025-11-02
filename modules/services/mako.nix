{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.mako";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    services.mako = {
      enable = true;
      settings.default-timeout = 10000;
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [libnotify mako];

    systemd.user.services.mako = {
      after = ["graphical-session.target"];
      description = "Mako notification daemon";
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";

        ExecCondition = ''
          ${lib.getExe pkgs.bash} -c '[ -n "$WAYLAND_DISPLAY" ]'
        '';

        ExecStart = ''
          ${lib.getExe' pkgs.mako "mako"}
        '';

        ExecReload = ''
          ${lib.getExe' pkgs.mako "makoctl"} reload
        '';

        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
