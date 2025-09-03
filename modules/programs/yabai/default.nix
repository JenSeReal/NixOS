{delib, ...}:
delib.module {
  name = "programs.yabai";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    services.yabai. enable = true;
  };
}
