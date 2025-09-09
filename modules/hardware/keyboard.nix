{
  delib,
  pkgs,
  ...
}: let
  ctrl_left = 30064771296;
  option_left = 30064771298;
  command_left = 30064771299;
in
  delib.module {
    name = "hardware.keyboard";
    options = with delib;
      moduleOptions {
        enable = boolOption false;
        xkb_layout = strOption "de";
        xkb_variant = strOption "nodeadkeys";
        xkb_options = strOption "caps:escape";
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

    nixos.ifEnabled = {cfg, ...}: {
      services.xserver.xkb = {
        layout = cfg.xkb_layout;
        variant = cfg.xkb_variant;
        options = cfg.xkb_options;
      };

      console = {
        packages = [pkgs.terminus_font];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
        useXkbConfig = true;
      };

      environment.sessionVariables = {
        XKB_LAYOUT = cfg.xkb_layout;
        XKB_VARIANT = cfg.xkb_variant;
        XKB_OPTIONS = cfg.xkb_options;
      };
    };
  }
