{delib, ...}:
delib.module {
  name = "desktop-environments.amethyst";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {
    myconfig.programs.amethyst.enable = true;
  };
}
