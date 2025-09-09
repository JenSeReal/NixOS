{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.clipcat";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.clipsync;
    };

  home.ifEnabled = {cfg, ...}: {
    systemd.user.services.clipsync = {
      Unit = {
        Description = "Clipboard synchronization between Wayland and X11";
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
