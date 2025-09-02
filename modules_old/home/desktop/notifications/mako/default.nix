{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.notifications.mako;
in {
  options.JenSeReal.desktop.notifications.mako = {
    enable = mkEnableOption "Mako.";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings.default-timeout = 10000;
    };
  };
}
