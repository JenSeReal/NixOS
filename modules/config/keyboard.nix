{delib, ...}: let
  ctrl_left = 30064771296;
  option_left = 30064771298;
  command_left = 30064771299;
in
  delib.module {
    name = "keyboard";
    options = with delib;
      moduleOptions {
        layout = strOption "de";
        variant = strOption "nodeadkeys";
        options = strOption "caps:escape";
      };

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

    nixos.always = {cfg, ...}: {
      console.useXkbConfig = true;
      services.xserver.xkb = {
        inherit (cfg) layout variant options;
      };
    };
  }
