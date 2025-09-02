{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.virtualisation.docker;
in
{
  options.JenSeReal.virtualisation.docker = {
    enable = mkEnableOption "Whether or not to enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ config.JenSeReal.user.name ];
  };
}
