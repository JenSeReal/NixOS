{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "hardware.graphics";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa
        libva
        amdvlk
        fwEctool
      ];
    };
  };
}
