{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.programs.desktop.screen-lockers.swaylock;
in {
  options.JenSeReal.programs.desktop.screen-lockers.swaylock = {
    enable = mkEnableOption "Whether or not to add swaylock.";
  };

  config = mkIf cfg.enable {
    security.pam.services.swaylock = {
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };

    environment.systemPackages = with pkgs; [swaylock-effects];
  };
}
