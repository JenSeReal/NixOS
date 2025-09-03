{delib, ...}:
delib.module {
  name = "desktop-environments.yabai";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {
    myconfig.programs = {
      yabai.enable = true;
      skhd.enable = true;
      sketchybar.enable = true;
    };
  };
}
