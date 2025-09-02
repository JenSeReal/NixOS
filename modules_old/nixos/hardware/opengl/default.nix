{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.JenSeReal;

let
  cfg = config.JenSeReal.hardware.opengl;
in
{
  options.JenSeReal.hardware.opengl = with types; {
    enable = mkEnableOption "Whether or not to enable opengl.";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa
        libva
        amdvlk
        inputs.fw-ectool.packages.${system}.ectool
      ];
    };
  };

}
