{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.${namespace}.services.desktop.clipboard-managers.clipcatd;
in {
  options.${namespace}.services.desktop.clipboard-managers.clipcatd = {
    enable = mkEnableOption "clipcatd";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.skim];

    services.clipcat = {
      enable = true;
      menuSettings = {
        finder = "skim";
      };
    };
  };
}
