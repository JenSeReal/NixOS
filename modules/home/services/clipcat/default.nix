{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    getExe'
    ;

  cfg = config.JenSeReal.services.clipcat;
in
{
  options.JenSeReal.services.clipcat = {
    enable = mkEnableOption "clipcat";
    package = mkPackageOption pkgs "clipcat" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.clipcat = {
      Unit = {
        After = [ "graphical-session.target" ];
        description = "clipcat daemon";
      };
      Install = {
        wantedBy = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${getExe' cfg.package "clipcatd"} --no-daemon";
      };
    };
  };
}
