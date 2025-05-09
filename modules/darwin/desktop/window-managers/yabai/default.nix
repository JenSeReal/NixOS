{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.desktop.window-managers.yabai;
in
{
  options.JenSeReal.desktop.window-managers.yabai = {
    enable = mkEnableOption "Enable yabai";
  };

  config = mkIf cfg.enable {
    services.yabai = {
      enable = true;

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

      extraConfig = ''
        yabai -m signal --add event=window_focused   action="sketchybar --trigger window_focus"
        yabai -m signal --add event=window_created   action="sketchybar --trigger windows_on_spaces"
        yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

        yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
        yabai -m rule --add label="App Store" app="^App Store$" manage=off
        yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
        yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
        yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
        yabai -m rule --add label="mpv" app="^mpv$" manage=off
        yabai -m rule --add label="Software Update" title="Software Update" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
        yabai -m rule --add app="^System Settings$"    manage=off
        yabai -m rule --add app="^System Information$" manage=off
        yabai -m rule --add title="Settings$"          manage=off
        yabai -m rule --add app="^Microsoft Outlook$" title!="^(Calendar|Inbox)" manage=off

        yabai -m rule --add app="^(LuLu|Vimac|Calculator|Software Update|Dictionary|VLC|System Preferences|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor)$" manage=off
        yabai -m rule --add label="Select file to save to" app="^Inkscape$" title="Select file to save to" manage=off

        yabai -m space 1 --label chat
        yabai -m space 2 --label conference
        yabai -m space 3 --label internet
        yabai -m space 4 --label code
        yabai -m space 5 --label terminal
        yabai -m space 6 --label productive
        yabai -m space 7 --label notes
        yabai -m space 8 --label utils

        yabai -m config --space chat layout stack
        yabai -m config --space conference layout stack

        yabai -m rule --add app="Slack" space=chat
        yabai -m rule --add app="Signal" space=chat
        yabai -m rule --add app="Messages" space=chat
        yabai -m rule --add app="Microsoft Outlook" space=chat

        yabai -m rule --add app="^zoom\.us$" space=conference
        yabai -m rule --add app="Microsoft Teams (work or school)" space=conference
        yabai -m rule --add app="^Microsoft Teams.*$" space=conference

        yabai -m rule --add app="Arc" space=internet
        yabai -m rule --add app="Firefox" space=internet

        yabai -m rule --add app="kitty" space=terminal
        yabai -m rule --add app="Terminal" space=terminal

        yabai -m rule --add app="Code" space=code
        yabai -m rule --add app="IntelliJ IDEA" space=code

        yabai -m rule --add app="Miro" space=productive

        yabai -m rule --add app="Spotify" space=utils
        yabai -m rule --add app="Bitwarden" space=utils

        yabai -m rule --add app="^Microsoft OneNote$" space=notes
      '';
    };
  };
}
