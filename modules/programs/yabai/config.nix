{delib, ...}:
delib.module {
  name = "programs.yabai";

  darwin.ifEnabled = {...}: {
    services.yabai = {
      config = {
        layout = "bsp";
        auto_balance = "off";

        top_padding = 0;
        bottom_padding = 0;
        left_padding = 0;
        right_padding = 0;

        window_gap = 8;
        window_topmost = "on";
        window_shadow = "float";
        window_placement = "second";
        window_opacity = "on";
        window_opacity_duration = 0.15;
        active_window_opacity = 1.0;
        normal_window_opacity = 0.95;

        # external_bar =
        #   "all:${builtins.toString config.services.spacebar.config.height}:0";

        mouse_modifier = "cmd";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        focus_follows_mouse = "autofocus";
        mouse_follows_focus = "on";
      };
    };
  };
}
