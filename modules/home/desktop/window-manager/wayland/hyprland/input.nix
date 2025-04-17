{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        master = {
          new_status = "master";
          orientation = "right";
        };

        dwindle = {
          preserve_split = true;
          pseudotile = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
          workspace_swipe_invert = true;
          workspace_swipe_distance = 120;
          workspace_swipe_min_speed_to_force = 10;
          workspace_swipe_cancel_ratio = 0.3;
        };

        input = {
          follow_mouse = 1;

          kb_layout = "$XKB_LAYOUT";
          kb_variant = "$XKB_VARIANT";
          kb_options = "$XKB_OPTIONS";
          numlock_by_default = true;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
          sensitivity = 0;
        };

        device = [
          {
            name = "at-translated-set-2-keyboard";
            numlock_by_default = false;
          }
          {
            name = "device:metadot---das-keyboard-das-keyboard";
            kb_layout = "us";
            kb_variant = "";
          }
          {
            name = "device:elan-touchscreen";
            enabled = "no";
          }
          {
            name = "device:elan-touchscreen-stylus";
            enabled = "no";
          }
        ];
      };
    };
  };
}
