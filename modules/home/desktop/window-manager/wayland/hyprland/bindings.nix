{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    types
    mkOption
    ;
  inherit (lib.${namespace}) mkStrOpt mkStrOpt' mkPackageOpt;

  hyprctl = getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  screen-recorder = getExe pkgs.${namespace}.screen-recorder;
  toggle = getExe pkgs.${namespace}.toggle;
  screenshotter = getExe pkgs.${namespace}.screenshotter;

  reload_script = pkgs.writeShellScript "reload.sh" ''
    killall .waybar-wrapped
    ${getExe config.programs.waybar.package} &

    hyprctl reload

    systemctl --user restart kanshi.service

    ${hyprctl} dispatch dpms on
  '';

  settingsModule = types.submodule {
    options = {
      modifyer = mkOption {
        type = types.submodule {
          options = {
            mainMod = mkStrOpt "SUPER" "The main modifyer";
            mainModCtrl = mkStrOpt "SUPER_CONTROL" "The main modifyer + Control";
            mainModShift = mkStrOpt "SUPER_SHIFT" "The main modifyer + Shift";
          };
        };
        default = { };
      };
      defaultPrograms = mkOption {
        type = types.submodule {
          options = {
            terminal = mkPackageOpt pkgs.wezterm "The default terminal to use";
            browser = mkPackageOpt pkgs.firefox "The browser to use";
            launcher = mkPackageOpt pkgs.yofi "The default launcher to use";
            secondaryLauncher = mkPackageOpt pkgs.anyrun "The secondary launcher to use";
            explorer = mkPackageOpt pkgs.nemo "The default explorer to use";
            screenLocker = mkPackageOpt pkgs.hyprlock "The default screen locker";
            logoutMenu = mkPackageOpt pkgs.wlogout "The default logoutMenu to use";
          };
        };
        default = { };
      };
      submaps = mkOption {
        type = types.listOf types.submodule {
          options = {
            name = mkOption { type = types.str; };
            binding = mkOption { type = types.str; };
            bind = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            resetKey = mkStrOpt' "escape";
          };
        };
      };
    };
  };

  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  options.JenSeReal.desktop.window-managers.hyprland = {
    settings = lib.mkOption {
      type = settingsModule;
      default = { };
      description = "The settings for bindings";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];

    wayland.windowManager.hyprland = {
      extraConfig = ''
        ### recorder submap
        bind = ${cfg.settings.modifyer.mainMod}, R, submap, record

        # will start a submap called "record"
        submap = record

        # sets repeatable binds for resizing the active window
        bind = , s, exec, ${toggle} ${screen-recorder} -s -d ${config.home.homeDirectory}/Pictures/Recordings && hyprctl dispatch submap reset
        bind = , w, exec, ${toggle} ${screen-recorder} -w -d ${config.home.homeDirectory}/Pictures/Recordings && hyprctl dispatch submap reset
        bind = , a, exec, ${toggle} ${screen-recorder} -a -d ${config.home.homeDirectory}/Pictures/Recordings && hyprctl dispatch submap reset

        # use reset to go back to the global submap
        bind = , escape, submap, reset

        # will reset the submap, which will return to the global submap
        submap = reset

        ### screenshot submap
        bind = ${cfg.settings.modifyer.mainMod}, S, submap, screenshot

        # will start a submap called "screenshot"
        submap = screenshot

        # sets repeatable binds for resizing the active window
        bind = , s, exec, ${screenshotter} copy screen && hyprctl dispatch submap reset
        bind = , o, exec, ${screenshotter} copy output && hyprctl dispatch submap reset
        bind = , w, exec, ${screenshotter} copy active && hyprctl dispatch submap reset
        bind = , a, exec, ${screenshotter} copy area && hyprctl dispatch submap reset
        bind = SHIFT, s, exec, ${screenshotter} save screen ${config.home.homeDirectory}/Pictures/Screenshots && hyprctl dispatch submap reset
        bind = SHIFT, o, exec, ${screenshotter} save output ${config.home.homeDirectory}/Pictures/Screenshots && hyprctl dispatch submap reset
        bind = SHIFT, w, exec, ${screenshotter} save active ${config.home.homeDirectory}/Pictures/Screenshots && hyprctl dispatch submap reset
        bind = SHIFT, a, exec, ${screenshotter} save area ${config.home.homeDirectory}/Pictures/Screenshots && hyprctl dispatch submap reset

        # use reset to go back to the global submap
        bind = , escape, submap, reset

        # will reset the submap, which will return to the global submap
        submap = reset
      '';

      settings = {
        bind =
          [
            "${cfg.settings.modifyer.mainMod}, RETURN, exec, ${getExe cfg.settings.defaultPrograms.terminal}"
            "${cfg.settings.modifyer.mainMod}, B, exec, ${getExe cfg.settings.defaultPrograms.browser}"
            "${cfg.settings.modifyer.mainMod}, D, exec, ${getExe cfg.settings.defaultPrograms.launcher}"
            "${cfg.settings.modifyer.mainModShift}, D, exec, ${getExe cfg.settings.defaultPrograms.secondaryLauncher}"
            "${cfg.settings.modifyer.mainMod}, E, exec, ${getExe cfg.settings.defaultPrograms.explorer}"
            "${cfg.settings.modifyer.mainModShift}, E, exec, ${getExe cfg.settings.defaultPrograms.logoutMenu}"

            "${cfg.settings.modifyer.mainModShift}, Q, killactive,"
            "${cfg.settings.modifyer.mainModShift}, C, exec, ${reload_script.outPath}"
            "${cfg.settings.modifyer.mainMod}, M, exit,"
            "${cfg.settings.modifyer.mainMod}, V, togglefloating,"
            "${cfg.settings.modifyer.mainMod}, P, pseudo,"
            "${cfg.settings.modifyer.mainMod}, J, togglesplit,"
            "${cfg.settings.modifyer.mainMod}, F, fullscreen,"
            "${cfg.settings.modifyer.mainMod}, F1, exec, ${getExe cfg.settings.defaultPrograms.screenLocker}"

            "${cfg.settings.modifyer.mainMod}, left, movefocus, l"
            "${cfg.settings.modifyer.mainMod}, right, movefocus, r"
            "${cfg.settings.modifyer.mainMod}, up, movefocus, u"
            "${cfg.settings.modifyer.mainMod}, down, movefocus, d"

            "${cfg.settings.modifyer.mainMod}, mouse_up, workspace, e+1"
            "${cfg.settings.modifyer.mainMod}, mouse_down, workspace, e-1"

            "${cfg.settings.modifyer.mainModShift},left,movewindow,l"
            "${cfg.settings.modifyer.mainModShift},right,movewindow,r"
            "${cfg.settings.modifyer.mainModShift},up,movewindow,u"
            "${cfg.settings.modifyer.mainModShift},down,movewindow,d"

            "${cfg.settings.modifyer.mainModCtrl}, right, workspace, +1"
            "${cfg.settings.modifyer.mainModCtrl}, left, workspace, -1"

            # special workspaces
            "${cfg.settings.modifyer.mainModShift},minus,movetoworkspace,special"
            "${cfg.settings.modifyer.mainMod},minus,togglespecialworkspace,"

          ]
          ++ (builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "${cfg.settings.modifyer.mainMod}, ${ws}, workspace, ${toString (x + 1)}"
                "${cfg.settings.modifyer.mainModCtrl}, ${ws}, movetoworkspace, ${toString (x + 1)}"
                "${cfg.settings.modifyer.mainModShift}, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            ) 10
          ));
        bindm = [
          "${cfg.settings.modifyer.mainMod}, mouse:272, movewindow"
          "${cfg.settings.modifyer.mainMod}, mouse:273, resizewindow"
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
        ];

      };
    };
  };
}
