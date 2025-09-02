{ config, lib, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [
          "float, class:viewnior"
          "float, class:feh"
          "float, class:wlogout"
          "float, class:file_progress"
          "float, class:confirm"
          "float, class:dialog"
          "float, class:download"
          "float, class:notification"
          "float, class:error"
          "float, class:splash"
          "float, class:confirmreset"
          "float, class:org.kde.polkit-kde-authentication-agent-1"
          "float, class:^(wdisplays)$"
          "size 1100 600, class:^(wdisplays)$"
          "float, class:^(blueman-manager)$"
          "float, class:^(nm-connection-editor)$"
          "float, initialClass:^(steam)$,title:^(Friends List|Steam Settings)(.*)$"

          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"

          "rounding 0, xwayland:1, floating:1"
          "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
          "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

          "bordercolor rgba(ed8796FF), class:org.kde.polkit-kde-authentication-agent-1"
          "dimaround, class:org.kde.polkit-kde-authentication-agent-1"
          "stayfocused, class:org.kde.polkit-kde-authentication-agent-1"

          "idleinhibit focus, class:^(steam).*"
          "idleinhibit focus, class:^(gamescope).*"
          "idleinhibit focus, class:.*(cemu|yuzu|ryujinx|emulationstation|retroarch).*"
          "idleinhibit fullscreen, title:.*(cemu|yuzu|ryujinx|emulationstation|retroarch).*"
          "idleinhibit fullscreen, title:^(.*(Twitch|TNTdrama|YouTube|Bally Sports|Video Entertainment|Plex)).*(Firefox).*$"
          "idleinhibit focus, title:^(.*(Twitch|TNTdrama|YouTube|Bally Sports|Video Entertainment|Plex)).*(Firefox).*$"
          "idleinhibit focus, class:^(mpv|.+exe)$"

          "stayfocused, title:^()$,class:^(steam)$"
          "minsize 1 1, title:^()$,class:^(steam)$"

          "workspace 9 silent, class:^(discord|WebCord|vesktop)$"
          "workspace 10 silent, class:^(steam)$"
        ];
      };
    };
  };
}
