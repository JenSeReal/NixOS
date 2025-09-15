{delib, ...}:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled = {
    wayland.windowManager.hyprland.settings = {
      general = {
        border_size = 2;
        # "col.active_border" = "rgba(7793D1FF)";
        # "col.inactive_border" = "rgb(5e6798)";
        gaps_in = 2;
        gaps_out = 0;
      };

      animations = {
        enabled = "yes";

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      decoration = {
        active_opacity = 1;
        fullscreen_opacity = 1.0;
        inactive_opacity = 1;
        rounding = 0;

        blur = {
          enabled = "yes";
          passes = 4;
          size = 5;
        };

        shadow = {
          enabled = "true";
          ignore_window = true;
          range = 20;
          render_power = 3;
          color_inactive = "0x22161925";
        };
      };

      misc = {
        disable_hyprland_logo = true;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        vrr = 2;
      };
    };
  };
}
