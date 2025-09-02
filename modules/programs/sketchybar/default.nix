{
  delib,
  pkgs,
  ...
}: let
  aerospace_script = pkgs.writeShellScript "aerospace.sh" ''
    #!/usr/bin/env bash

    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set $NAME background.drawing=on
    else
      sketchybar --set $NAME background.drawing=off
    fi
  '';
in
  delib.module {
    name = "programs.sketchybar";

    options = delib.singleEnableOption false;

    darwin.ifEnabled = {...}: {
      services.sketchybar = {
        enable = true;
        config = ''
          sketchybar --add event aerospace_workspace_change

          for sid in $(aerospace list-workspaces --all); do
            sketchybar --add item space.$sid left \
              --subscribe space.$sid aerospace_workspace_change \
              --set space.$sid \
              background.color=0x44ffffff \
              background.corner_radius=5 \
              background.height=20 \
              background.drawing=off \
              label="$sid" \
              click_script="aerospace workspace $sid" \
              script="${aerospace_script.outPath} $sid"
          done
        '';
      };
    };
  }
