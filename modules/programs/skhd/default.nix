{
  delib,
  pkgs,
  ...
}: let
  mkScript = name: file:
    pkgs.writeShellApplication {
      inherit name;
      checkPhase = "";
      text = builtins.readFile file;
    };

  launch-kitty = mkScript "launch" ./launch-kitty.sh;
  toggle-float = mkScript "toogle-float" ./toggle-float.sh;
in
  delib.module {
    name = "programs.skhd";
    options = delib.singleEnableOption false;

    darwin.ifEnabled = {...}: {
      services.skhd = {
        enable = true;

        skhdConfig = ''
          # Movement
          shift + cmd - h : yabai -m window --focus west
          shift + cmd - j : yabai -m window --focus south
          shift + cmd - k : yabai -m window --focus north
          shift + cmd - l : yabai -m window --focus east

          # Window Movement
          lctrl + shift + cmd - h : yabai -m window --swap west
          lctrl + shift + cmd - j : yabai -m window --swap south
          lctrl + shift + cmd - k : yabai -m window --swap north
          lctrl + shift + cmd - l : yabai -m window --swap east

          # Window Resize
          lctrl + cmd - h : yabai -m window --resize left:-50:0; \
                            yabai -m window --resize right:-50:0
          lctrl + cmd - j : yabai -m window --resize bottom:0:50; \
                            yabai -m window --resize top:0:50
          lctrl + cmd - k : yabai -m window --resize top:0:-50; \
                            yabai -m window --resize bottom:0:-50
          lctrl + cmd - l : yabai -m window --resize right:50:0; \
                            yabai -m window --resize left:50:0

          lctrl + alt - h : yabai -m window --resize left:-10:0; \
                            yabai -m window --resize right:-10:0
          lctrl + alt - j : yabai -m window --resize bottom:0:10; \
                      yabai -m window --resize top:0:10
          lctrl + alt - k : yabai -m window --resize top:0:-10; \
                            yabai -m window --resize bottom:0:-10
          lctrl + alt - l : yabai -m window --resize right:10:0; \
                            yabai -m window --resize left:10:0

          lctrl + cmd - e : yabai -m space --balance

          # Move Window To Space
          lctrl + shift + cmd - l : yabai -m window --space last; yabai -m space --focus last
          lctrl + shift + cmd - p : yabai -m window --space prev; yabai -m space --focus prev
          lctrl + shift + cmd - n : yabai -m window --space next; yabai -m space --focus next
          lctrl + shift + cmd - f : yabai -m window --space first; yabai -m space --focus first

          lctrl + shift + cmd - 1 : yabai -m window --space 1
          lctrl + shift + cmd - 2 : yabai -m window --space 2
          lctrl + shift + cmd - 3 : yabai -m window --space 3
          lctrl + shift + cmd - 4 : yabai -m window --space 4
          lctrl + shift + cmd - 5 : yabai -m window --space 5
          lctrl + shift + cmd - 6 : yabai -m window --space 6
          lctrl + shift + cmd - 7 : yabai -m window --space 7
          lctrl + shift + cmd - 8 : yabai -m window --space 8

          # Insert Direction
          lctrl + shift + cmd - v : yabai -m window --insert south
          lctrl + shift + cmd - b : yabai -m window --insert east
          lctrl + shift + cmd - s : yabai -m window --insert stack

          # Floating Windows
          shift + cmd - space : ${toggle-float}/bin/toggle-float

          # Terminal
          shift + cmd - return : ${launch-kitty}/bin/launch

          # Fullscreen
          alt - f : yabai -m window --toggle zoom-fullscreen
          shift + alt - f : yabai -m window --toggle native-fullscreen

          # Restart Yabai
          shift + lctrl + alt - r : \
            /usr/bin/env osascript <<< \
              "display notification \"Restarting Yabai\" with title \"Yabai\""; \
            launchctl kickstart -k "gui/$UID/org.nixos.yabai"

          # Restart Spacebar
          shift + lctrl + alt - s : \
            /usr/bin/env osascript <<< \
              "display notification \"Restarting Spacebar\" with title \"Spacebar\""; \
            launchctl kickstart -k "gui/$UID/org.nixos.spacebar"
        '';
      };
    };
  }
