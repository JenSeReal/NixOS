{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    types
    mkEnableOption
    mkIf
    ;
  inherit (types) package listOf;
  inherit (lib.${namespace}) enabled mkOpt;
  cfg = config.JenSeReal.hardware.audio.pipewire;
in {
  options.JenSeReal.hardware.audio.pipewire = {
    enable = mkEnableOption "Whether or not to enable pipewire.";
    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      pkgs.easyeffects
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [
        pkgs.pulsemixer
        pkgs.pavucontrol
        pkgs.helvum
      ]
      ++ cfg.extra-packages;

    # sound = enabled;
    services.pulseaudio = {
      package = pkgs.pulseaudioFull;
    };
    security.rtkit = enabled;

    services.pipewire = {
      enable = true;
      alsa = enabled;
      jack = enabled;
      pulse = enabled;
      wireplumber = enabled;
    };

    JenSeReal.user.extraGroups = ["audio"];
  };
}
