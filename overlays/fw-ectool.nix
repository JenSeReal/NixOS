{
  inputs,
  delib,
  pkgs,
  ...
}:
delib.overlayModule {
  name = "fw-ectool";
  overlay = final: prev: {
    fwEctool = inputs.fw-ectool.packages.${pkgs.system}.ectool;
  };
}
