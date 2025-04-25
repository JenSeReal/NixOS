{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  aerospace_script = pkgs.writeShellScript "aerospace.sh" ''
    #!/usr/bin/env bash

    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set $NAME background.drawing=on
    else
      sketchybar --set $NAME background.drawing=off
    fi
  '';

  cfg = config.${namespace}.desktop.bars.sketchybar;
in
{
  options.${namespace}.desktop.bars.sketchybar = {
    enable = mkEnableOption "Wether to enable sketchybar.";
  };

  config = mkIf cfg.enable {
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
