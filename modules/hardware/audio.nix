{delib, ...}:
delib.module {
  name = "hardware.audio";

  darwin.always = {
    system.defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
      };
      ".GlobalPreferences"."com.apple.sound.beep.sound" = null;
    };
  };
}
