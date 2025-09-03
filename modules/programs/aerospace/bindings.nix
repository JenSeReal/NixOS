{delib, ...}: let
  mod = "ctrl";
in
  delib.module {
    name = "programs.aerospace";

    home.ifEnabled = {...}: {
      programs.aerospace.userSettings.mode = {
        main.binding = {
          "${mod}-h" = ["focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors left" "move-mouse window-lazy-center"];
          "${mod}-j" = ["focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors down" "move-mouse window-lazy-center"];
          "${mod}-k" = ["focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors up" "move-mouse window-lazy-center"];
          "${mod}-l" = ["focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors right" "move-mouse window-lazy-center"];

          "${mod}-cmd-h" = "move left";
          "${mod}-cmd-j" = "move down";
          "${mod}-cmd-k" = "move up";
          "${mod}-cmd-l" = "move right";

          cmd-h = []; # Disable "hide application"
          cmd-alt-h = [];

          "${mod}-enter" = "exec-and-forget open -a wezterm";

          "${mod}-period" = "layout tiles horizontal vertical";
          "${mod}-comma" = "layout accordion horizontal vertical";
          "${mod}-f" = "fullscreen";
          "${mod}-shift-f" = "layout floating tiling";
          "${mod}-shift-c" = "reload-config";

          "${mod}-1" = "workspace internet";
          "${mod}-2" = "workspace code";
          "${mod}-3" = "workspace terminal";
          "${mod}-4" = "workspace productive";
          "${mod}-5" = "workspace 5";
          "${mod}-6" = "workspace 6";
          "${mod}-7" = "workspace notes";
          "${mod}-8" = "workspace utils";
          "${mod}-9" = "workspace chat";
          "${mod}-0" = "workspace conference";

          "${mod}-shift-1" = "move-node-to-workspace internet";
          "${mod}-shift-2" = "move-node-to-workspace code";
          "${mod}-shift-3" = "move-node-to-workspace terminal";
          "${mod}-shift-4" = "move-node-to-workspace productive";
          "${mod}-shift-5" = "move-node-to-workspace 5";
          "${mod}-shift-6" = "move-node-to-workspace 6";
          "${mod}-shift-7" = "move-node-to-workspace notes";
          "${mod}-shift-8" = "move-node-to-workspace utils";
          "${mod}-shift-9" = "move-node-to-workspace chat";
          "${mod}-shift-0" = "move-node-to-workspace conference";

          "${mod}-tab" = "workspace-back-and-forth";

          "${mod}-space" = "focus-monitor --wrap-around next";
          "${mod}-shift-space" = "move-node-to-monitor --wrap-around --focus-follows-window next";

          "${mod}-n" = "workspace next";
          "${mod}-p" = "workspace prev";

          "${mod}-shift-n" = "move-node-to-workspace --wrap-around next --focus-follows-window";
          "${mod}-shift-p" = "move-node-to-workspace --wrap-around prev --focus-follows-window";

          "${mod}-minus" = "move-node-to-workspace scratchpad";
          "${mod}-shift-minus" = "workspace scratchpad";

          "${mod}-shift-semicolon" = "mode service";
          "${mod}-r" = "mode resize";
        };

        service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          backspace = [
            "close-all-windows-but-current"
            "mode main"
          ];
        };

        resize.binding = {
          minus = "resize smart -50";
          equal = "resize smart +50";
        };
      };
    };
  }
