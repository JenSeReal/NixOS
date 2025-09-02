{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.desktop.idle-managers.hypridle;
in {
  options.${namespace}.services.desktop.idle-managers.hypridle = {
    enable = mkEnableOption "Whether or not to add hypridle.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [hypridle];
  };
}
