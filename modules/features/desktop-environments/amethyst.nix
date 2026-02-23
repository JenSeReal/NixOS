{delib, ...}:
delib.module {
  name = "features.desktop-environments.amethyst";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {
    myconfig.programs.amethyst.enable = true;
  };
}
