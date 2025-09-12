{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "hardware.opengl";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
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
