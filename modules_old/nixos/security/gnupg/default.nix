{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.security.gnupg;
in
{
  options.JenSeReal.security.gnupg = with types; {
    enable = mkEnableOption "Whether or not to enable gnupg.";
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = with pkgs; {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = lib.mkForce pinentry-qt;
    };
  };
}
