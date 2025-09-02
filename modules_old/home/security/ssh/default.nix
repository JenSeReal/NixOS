{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.security.ssh;
in
{
  options.JenSeReal.security.ssh = {
    enable = mkEnableOption "Enable ssh.";
  };

  config = mkIf cfg.enable { programs.ssh.enable = true; };
}
