{
  delib,
  lib,
  ...
}: let
  modifierKey = "ctrl";
in
  delib.module {
    name = "programs.aerospace";

    home.ifEnabled = {myconfig, ...}: {
      programs.aerospace = {
        userSettings = {
          start-at-login = true;
          automatically-unhide-macos-hidden-apps = true;
          after-login-command = lib.mkIf myconfig.programs.sketchybar.enable [
            "exec-and-forget sketchybar"
          ];
          after-startup-command = lib.mkIf myconfig.programs.jankyborders.enable [
            "exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0"
          ];
          accordion-padding = 10;
          default-root-container-layout = "accordion";
          default-root-container-orientation = "auto";
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          non-empty-workspaces-root-containers-layout-on-startup = "smart";
          on-window-detected = [
            {
              "if" = {
                app-id = "com.apple.systempreferences";
                run = [
                  "layout floating"
                ];
              };
            }
            {
              "if" = {
                app-id = "org.openvpn.client.app";
                run = [
                  "layout floating"
                ];
              };
            }
            {
              "if" = {
                app-id = "org.mozilla.firefox";
                run = [
                  "move-node-to-workspace internet"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.microsoft.VSCode";
                run = [
                  "move-node-to-workspace code"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.apple.Terminal";
                run = [
                  "move-node-to-workspace terminal"
                ];
              };
            }
            {
              "if" = {
                app-id = "net.kovidgoyal.kitty";
                run = [
                  "move-node-to-workspace terminal"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.github.wez.wezterm";
                run = [
                  "move-node-to-workspace terminal"
                ];
              };
            }

            {
              "if" = {
                app-id = "com.electron.realtimeboard";
                run = [
                  "move-node-to-workspace productive"
                ];
              };
            }

            {
              "if" = {
                app-id = "com.microsoft.onenote.mac";
                run = [
                  "move-node-to-workspace notes"
                ];
              };
            }

            {
              "if" = {
                app-id = "com.electron.logseq";
                run = [
                  "move-node-to-workspace notes"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.spotify.client";
                run = [
                  "move-node-to-workspace notes"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.tinyspeck.slackmacgap";
                run = [
                  "move-node-to-workspace chat"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.microsoft.Outlook";
                run = [
                  "move-node-to-workspace chat"
                ];
              };
            }
            {
              "if" = {
                app-id = "com.microsoft.teams2";
                run = [
                  "move-node-to-workspace conference"
                ];
              };
            }
            {
              "if" = {
                app-id = "us.zoom.xos";
                run = [
                  "move-node-to-workspace conference"
                ];
              };
            }
          ];

          on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

          config.exec-on-workspace-change = lib.mkIf myconfig.programs.sketchybar.enable [
            "/bin/bash"
            "-c"
            "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          gaps = {
            inner.horizontal = 0;
            inner.vertical = 0;
            outer.left = 0;
            outer.bottom = 0;
            outer.top = 0;
            outer.right = 0;
          };

          "mode.main.binding" = {
            "${modifierKey}-h" = "focus left";
            "${modifierKey}-j" = "focus down";
            "${modifierKey}-k" = "focus up";
            "${modifierKey}-l" = "focus right";

            "${modifierKey}-cmd-h" = "move left";
            "${modifierKey}-cmd-j" = "move down";
            "${modifierKey}-cmd-k" = "move up";
            "${modifierKey}-cmd-l" = "move right";

            cmd-h = []; # Disable "hide application"
            cmd-alt-h = []; # Disable "hide others"

            "${modifierKey}-enter" = "exec-and-forget wezterm";

            "${modifierKey}-period" = "layout tiles horizontal vertical";
            "${modifierKey}-comma" = "layout accordion horizontal vertical";
            "${modifierKey}-f" = "fullscreen";
            "${modifierKey}-shift-c" = "reload-config";

            "${modifierKey}-1" = "workspace internet";
            "${modifierKey}-2" = "workspace code";
            "${modifierKey}-3" = "workspace terminal";
            "${modifierKey}-4" = "workspace productive";
            "${modifierKey}-5" = "workspace 5";
            "${modifierKey}-6" = "workspace 6";
            "${modifierKey}-7" = "workspace notes";
            "${modifierKey}-8" = "workspace utils";
            "${modifierKey}-9" = "workspace chat";
            "${modifierKey}-0" = "workspace conference";

            "${modifierKey}-shift-1" = "move-node-to-workspace 1";
            "${modifierKey}-shift-2" = "move-node-to-workspace 2";
            "${modifierKey}-shift-3" = "move-node-to-workspace 3";
            "${modifierKey}-shift-4" = "move-node-to-workspace 4";
            "${modifierKey}-shift-5" = "move-node-to-workspace 5";
            "${modifierKey}-shift-6" = "move-node-to-workspace 6";
            "${modifierKey}-shift-7" = "move-node-to-workspace 7";
            "${modifierKey}-shift-8" = "move-node-to-workspace 8";
            "${modifierKey}-shift-9" = "move-node-to-workspace 9";
            "${modifierKey}-shift-0" = "move-node-to-workspace 0";

            "${modifierKey}-tab" = "workspace-back-and-forth";
            "${modifierKey}-shift-tab" = "move-workspace-to-monitor --wrap-around next";

            "${modifierKey}-shift-semicolon" = "mode service";
            "${modifierKey}-r" = "mode resize";
          };

          "mode.service.binding" = {
            esc = [
              "reload-config"
              "mode main"
            ];
            r = [
              "flatten-workspace-tree"
              "mode main"
            ]; # reset layout
            f = [
              "layout floating tiling"
              "mode main"
            ]; # Toggle between floating and tiling layout
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
          };

          "mode.resize.binding" = {
            minus = "resize smart -50";
            equal = "resize smart +50";
          };
        };
      };
    };
  }
