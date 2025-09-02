{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.security.keyring;
in
{
  options.JenSeReal.security.keyring = {
    enable = mkEnableOption "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
