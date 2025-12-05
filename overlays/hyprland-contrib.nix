{
  inputs,
  delib,
  pkgs,
  ...
}:
delib.overlayModule {
  name = "hyprland-contrib";
  overlay = final: prev: {
    hyprlandContrib = inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system};
  };
}
