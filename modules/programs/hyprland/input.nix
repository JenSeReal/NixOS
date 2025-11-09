{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled = {myconfig, ...}: {
    wayland.windowManager.hyprland.settings = {
      master = {
        new_status = "master";
        orientation = "right";
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      gestures = {
        workspace_swipe_invert = true;
        workspace_swipe_distance = 120;
        workspace_swipe_min_speed_to_force = 10;
        workspace_swipe_cancel_ratio = 0.3;
      };

      gesture = [
        "3, horizontal, workspace"
        "4, left, dispatcher, movewindow, mon:-1"
        "4, right, dispatcher, movewindow, mon:+1"
        "4, pinch, fullscreen"
      ];

      input = {
        follow_mouse = 1;

        kb_layout = myconfig.keyboard.layout;
        kb_variant = myconfig.keyboard.variant;
        kb_options = myconfig.keyboard.options;
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
}
