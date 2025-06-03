{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.system.input.fingerprint;
in {
  options.${namespace}.system.input.fingerprint = {
    enable = mkEnableOption "Whether or not to enable fingerprint.";
  };

  config = mkIf cfg.enable {security.pam.services.sudo_local.touchIdAuth = true;};
}
