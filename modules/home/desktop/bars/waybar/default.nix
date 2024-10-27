{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe';
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.desktop.bars.waybar;

  style = builtins.readFile ./styles.css;
  synthwave84 = builtins.readFile ./synthwave84.css;
in
{
  options.${namespace}.desktop.bars.waybar = {
    enable = mkBoolOpt false "Whether or not to enable waybar.";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          spacing = 0;
          modules-left = [
            "sway/workspaces"
            "custom/arGap"
            "idle_inhibitor"
            "custom/wsGap"
          ];
          modules-center = [
            "custom/mgl"
            "clock"
            "custom/mgr"
          ];
          modules-right = [
            "custom/paGap"
            "pulseaudio"
            "custom/blGap"
            "backlight"
            "custom/baGap"
            "battery"
            "custom/netGap"
            "network"
            "custom/trayGap"
            "tray"
          ];
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "󰊪";
              "deactivated" = "󰓠";
            };
          };
          "sway/window" = {
            "all-outputs" = true;
            "offscreen-css" = true;
            "offscreen-css-text" = "(inactive)";
          };
          "custom/arGap" = {
            format = "";
            tooltip = false;
          };
          "custom/archthing" = {
            format = "";
            tooltip = false;
            "on-click" = "rofi -show drun -normal-window -steal-focus -modes drun,run,filebrowser,window";
          };
          "custom/wsGap" = {
            format = "";
            tooltip = false;
          };
          "custom/mgl" = {
            format = "";
            tooltip = false;
          };
          "custom/mgr" = {
            format = "";
            tooltip = false;
          };
          "custom/paGap" = {
            format = "";
            tooltip = false;
          };
          "custom/blGap" = {
            format = "";
            tooltip = false;
          };
          "custom/baGap" = {
            format = "";
            tooltip = false;
          };
          "custom/netGap" = {
            format = "";
            tooltip = false;
          };
          "custom/clGap" = {
            format = "";
            tooltip = false;
          };
          "custom/trayGap" = {
            format = "";
            tooltip = false;
          };
          clock = {
            format = "{:%H:%M:%S}";
            "tooltip-format" = "{:%A, %B %d, %Y | %H:%M %Z}";
            "on-click" = "galendae";
            "interval" = 1;
          };
          backlight = {
            format = "{icon}";
            tooltip = true;
            "tooltip-format" = "{percent}%";
            "format-icons" = [
              "󰛩"
              "󱩎"
              "󱩏"
              "󱩐"
              "󱩑"
              "󱩒"
              "󱩓"
              "󱩔"
              "󱩕"
              "󱩖"
              "󰛨"
            ];
          };
          "battery" = {
            "interval" = 60;
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon}";
            "format-critical" = "󱉞";
            "format-icons" = {
              "default" = [
                "󰂎"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              "charging" = [
                "󰢟"
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
              "plugged" = "󱈑";
            };
          };
          network = {
            format = "{icon}";
            "tooltip-format" = "{essid}  |  {ipaddr}  |  {ifname}";
            "format-icons" = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            "on-click-right" = "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
            "format-disconnected" = "󰤭";
          };
          "pulseaudio" = {
            "tooltip" = true;
            "tooltip-format" = "{volume}%";
            "scroll-step" = 5;
            "format" = "{icon}";
            "format-bluetooth" = "󰂰";
            "format-muted" = "󰖁";
            "format-icons" = {
              "default" = [
                ""
                ""
                ""
              ];
            };
            "on-click" = "pavucontrol";
            "enable-bar-scroll" = true;
          };
        };
      };
      style = ''
        ${style}

        ${synthwave84}
      '';
    };
  };
}

# config = mkIf cfg.enable {
#     programs.waybar = {
#       enable = true;
#       settings = {
#         mainBar = {
#           clock = { format = "{:%Y-%m-%d %H:%M}"; };
#           layer = "top";
#           position = "bottom";
#           modules-left = [ "hyprland/workspaces" ];
#           modules-right = [
#             "hyprland/submap"
#             "idle_inhibitor"
#             "pulseaudio"
#             "network"
#             "cpu"
#             "memory"
#             "temperature"
#             "tray"
#             "battery"
#             "clock"
#           ];
#         };
#       };
#     };
#   };
