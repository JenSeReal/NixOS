{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    getExe'
    mkOptionDefault
    mkEnableOption
    ;
  cfg = config.${namespace}.desktop.window-manager.wayland.sway;

  modifier = config.wayland.windowManager.sway.config.modifier;

  clamshell = pkgs.writeShellScript "clamshell.sh" ''
    # Set your laptop screen name
    set $laptop_screen 'eDP-1'

    # Clamshell mode or lock & sleep
    # This is a if/else statement: [ outputs_count == 1 ] && true || false
    bindswitch --reload --locked lid:on exec '[ $(swaymsg -t get_outputs | grep name | wc -l) == 1 ] && (${getExe' pkgs.systemd "systemctl"} suspend -f) || (swaymsg output $laptop_screen disable)'

    bindswitch --reload --locked lid:off output $laptop_screen enable
  '';
in
{
  options.${namespace}.desktop.window-manager.wayland.sway = {
    enable = mkEnableOption "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GSK_RENDERER = "gl";
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${getExe config.programs.wezterm.package}";
        menu = "${getExe pkgs.yofi} binapps";
        bars = [ { command = "${getExe pkgs.waybar}"; } ];
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
            xkb_numlock = "enabled";
          };

          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };
        startup = [
          {
            command = "${getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator";
            always = true;
          }
          {
            command = "${clamshell.outPath}";
            always = true;
          }
        ];
        keybindings = mkOptionDefault {
          "${modifier}+l" = "exec ${getExe config.programs.swaylock.package}";
          "${modifier}+Shift+c" = "reload; exec ${getExe' pkgs.systemd "systemctl"} --user restart kanshi";
        };
        window.titlebar = false;
        window.hideEdgeBorders = "smart";
        window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "^firefox$";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              class = "^Firefox$";
            };
          }
          {
            command = "floating enable";
            criteria = {
              class = "steam";
            };

          }
          {
            command = "floating disable";
            criteria = {
              class = "steam";
              title = "^Steam$";
            };
          }
        ];
        assigns = {
          "1" = [
            { title = "^(.*(Twitch|TNTdrama|YouTube|Bally Sports|Video Entertainment|Plex)).*(Firefox).*$"; }
          ];
          "2" = [
            { app_id = "^Code$"; }
            { app_id = "^neovide$"; }
            { app_id = "^GitHub Desktop$"; }
            { app_id = "^GitKraken$"; }
          ];
          "3" = [ ];
          "4" = [
            { class = "^steam_app_.*$"; }
          ];
          "5" = [
            { app_id = "^thunderbird$"; }
          ];
          "6" = [
            { app_id = "^mpv|vlc|VLC|mpdevil$"; }
            { app_id = "^Spotify$"; }
            { title = "^Spotify$"; }
            { title = "^Spotify Free$"; }
            { class = "^elisa$"; }
          ];
          "7" = [ ];
          "8" = [ { app_id = "^io.github.lawstorant.boxflat$"; } ];
          "9" = [
            { app_id = "^(discord|WebCord)$"; }
            { app_id = "^Element$"; }
          ];
          "10" = [
            { class = "^steam$"; }
            { app_id = "^net.lutris.Lutris$"; }
          ];

        };

        floating = {
          criteria = [
            # Float specific applications
            { class = "Rofi"; }
            { class = "viewnior"; }
            { class = "feh"; }
            { class = "wlogout"; }
            { class = "file_progress"; }
            { class = "confirm"; }
            { class = "dialog"; }
            { class = "download"; }
            { class = "notification"; }
            { class = "error"; }
            { class = "splash"; }
            { class = "confirmreset"; }
            { class = "org.kde.polkit-kde-authentication-agent-1"; }
            { class = "wdisplays"; }
            { class = "blueman-manager"; }
            { class = "nm-connection-editor"; }
            { title = "^(floatterm)$"; }
          ];
        };
      };
    };
  };
}
