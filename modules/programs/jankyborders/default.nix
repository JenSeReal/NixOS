{delib, ...}:
delib.module {
  name = "programs.jankyborders";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    services.jankyborders.enable = true;
  };
}
