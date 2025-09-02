{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.sound;
in
{
  options.${namespace}.system.sound = {
    enable = mkEnableOption "Wether to enable sound configuration.";
  };

  config = mkIf cfg.enable {
    system.defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
      };
      ".GlobalPreferences"."com.apple.sound.beep.sound" = null;
    };
  };
}
