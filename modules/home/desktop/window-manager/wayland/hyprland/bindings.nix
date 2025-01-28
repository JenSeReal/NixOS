{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;

  reload_script = pkgs.writeShellScript "reload.sh" ''
    killall .waybar-wrapped
    ${getExe config.programs.waybar.package} &

    hyprctl reload

    systemctl --user restart kanshi.service
  '';
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mainMod, RETURN, exec, $term"
          "$mainMod, B, exec, $browser"
          "$mainMod, D, exec, $launcher"
          "$mainModShift, D, exec, anyrun"
          "$mainMod, E, exec, $explorer"
          "$mainModShift, E, exec, $logout"

          "$mainModShift, Q, killactive,"
          "$mainModShift, C, exec, ${reload_script.outPath}"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, F, fullscreen,"
          "$mainMod, F1, exec, ${getExe config.programs.swaylock.package}"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, mouse_up, workspace, e+1"
          "$mainMod, mouse_down, workspace, e-1"

          "$mainModShift,left,movewindow,l"
          "$mainModShift,right,movewindow,r"
          "$mainModShift,up,movewindow,u"
          "$mainModShift,down,movewindow,d"

          "$mainModControl, right, workspace, +1"
          "$mainModControl, left, workspace, -1"

          "$mainModShift,minus,movetoworkspace,special"
          "$mainMod,minus,togglespecialworkspace,"
        ] ++ (builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainModControl, ${ws}, movetoworkspace, ${toString (x + 1)}"
            "$mainModShift, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ]) 10));
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
