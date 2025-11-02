{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.waybar";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.waybar;
    };

  home.ifEnabled = {
    myconfig,
    cfg,
    ...
  }: {
    programs.waybar = {
      enable = true;
      package = cfg.package;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          spacing = 0;
          modules-left = [
            "${
              if myconfig.programs.hyprland.enable
              then "hyprland/workspaces"
              else "sway/workspaces"
            }"
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
            "hyprland/submap"
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
          "hyprland/workspaces" = {
            "format" = "{icon}";
            "on-scroll-up" = "hyprctl dispatch workspace e+1";
            "on-scroll-down" = "hyprctl dispatch workspace e-1";
          };
          "hyprland/submap" = {
            "format" = "{}";
            "tooltip" = false;
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
            "on-click-right" = "${lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
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
    };
  };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };
}
