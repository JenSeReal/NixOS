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
        fw-ectool
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
    };
    environment.variables = {
      RUSTICL_ENABLE = "radv";
      OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";
    };
  };
}
