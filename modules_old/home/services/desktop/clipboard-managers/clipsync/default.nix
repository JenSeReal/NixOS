{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    getExe
    ;

  cfg = config.${namespace}.services.desktop.clipboard-managers.clipsync;
in
{
  options.${namespace}.services.desktop.clipboard-managers.clipsync = {
    enable = mkEnableOption "Enable clipsync systemd service";
    package = mkPackageOption pkgs.${namespace} "clipsync" { };
  };

  config = mkIf cfg.enable {
    systemd.user.services.clipsync = {
      Unit = {
        Description = "Clipboard synchronization between Wayland and X11";
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${getExe cfg.package}";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
