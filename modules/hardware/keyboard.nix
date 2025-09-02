{delib, ...}: let
  ctrl_left = 30064771296;
  option_left = 30064771298;
  command_left = 30064771299;
in
  delib.module {
    name = "hardware.keyboard";

    darwin.always = {
      system = {
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
          userKeyMapping = [
            {
              HIDKeyboardModifierMappingSrc = ctrl_left;
              HIDKeyboardModifierMappingDst = command_left;
            }
            {
              HIDKeyboardModifierMappingSrc = command_left;
              HIDKeyboardModifierMappingDst = option_left;
            }
            {
              HIDKeyboardModifierMappingSrc = option_left;
              HIDKeyboardModifierMappingDst = ctrl_left;
            }
          ];
        };
        defaults.NSGlobalDomain = {
          AppleKeyboardUIMode = 3;
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
        };
      };
    };
  }
