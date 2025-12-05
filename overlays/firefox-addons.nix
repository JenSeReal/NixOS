{
  inputs,
  delib,
  pkgs,
  ...
}:
delib.overlayModule {
  name = "firefox-addons";
  overlay = final: prev: {
    firefoxAddons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  };
}
