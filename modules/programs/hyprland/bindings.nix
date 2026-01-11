{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland";

  options = with delib;
    moduleOptions {
      settings = lib.mkOption {
        type = (import ./modules/settings.nix {inherit delib lib pkgs;}).settingsModule;
        default = {};
        description = "The settings for bindings";
      };
    };

  home.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: let
    hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
    scratchpad = lib.getExe pkgs.hyprlandContrib.scratchpad;
    playerctl = lib.getExe pkgs.playerctl;
    wpctl = lib.getExe' pkgs.wireplumber "wpctl";
    clipcat-menu = lib.getExe' pkgs.clipcat "clipcat-menu";
    killall = lib.getExe pkgs.killall;
    hyprlock = lib.getExe pkgs.hyprlock;

    gamemode_script = pkgs.writeShellScript "gamemode.sh" ''
      #!/usr/bin/env sh
      HYPRGAMEMODE=$(${hyprctl} getoption animations:enabled | ${lib.getExe pkgs.gawk} 'NR==1{print $2}')
      if [ "$HYPRGAMEMODE" = 1 ] ; then
          ${hyprctl} --batch "\
              keyword animations:enabled 0;\
              keyword animation borderangle,0; \
              keyword decoration:shadow:enabled 0;\
              keyword decoration:blur:enabled 0;\
              keyword decoration:fullscreen_opacity 1;\
              keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
          ${hyprctl} notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
          exit
      else
          ${hyprctl} notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
          ${hyprctl} reload
          exit 0
      fi
      exit 1
    '';

    reload_script = pkgs.writeShellScript "reload.sh" ''
      ${killall} .waybar-wrapped
      ${lib.getExe myconfig.programs.waybar.package} &

      ${hyprctl} reload

      systemctl --user restart kanshi.service

      ${hyprctl} dispatch dpms on
    '';
    processSubmap = submap: let
      # Process action bindings with automatic submap reset
      processBinds = actionType: binds:
        map (
          bind: let
            parts = lib.splitString ", " bind;
            modifiers = lib.head parts;
            key = lib.elemAt parts 1;
            action = lib.elemAt parts 2;
            command = lib.concatStringsSep ", " (lib.drop 3 parts);
          in "${actionType} = ${modifiers}, ${key}, ${action}, hyprctl dispatch submap reset && ${command}"
        )
        binds;

      # Process all action types dynamically
      actionCommands = lib.flatten (
        lib.mapAttrsToList (actionType: binds: processBinds actionType binds) submap.actions
      );

      # Process exit bindings
      exitCommands = map (bind: "bind = ${bind}, submap, reset") submap.exit.bind;

      # Build the full configuration
      fullConfig =
        [
          "bind = ${submap.trigger}, submap, ${submap.name}"
          "# will start a submap called \"${submap.name}\""
          "submap = ${submap.name}"
          "# sets repeatable binds for the submap"
        ]
        ++ actionCommands
        ++ [
          "# use reset to go back to the global submap"
        ]
        ++ exitCommands
        ++ [
          "# will reset the submap, which will return to the global submap"
          "submap = reset"
        ];
    in
      lib.concatStringsSep "\n" fullConfig;
  in {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        ${lib.concatMapStringsSep "\n\n" processSubmap cfg.settings.submaps}
      '';

      settings = {
        bind =
          [
            "${cfg.settings.modifyer.mainModShift}, Q, killactive,"
            "${cfg.settings.modifyer.mainModShift}, C, exec, ${reload_script.outPath}"
            "${cfg.settings.modifyer.mainMod}, M, exit,"
            "${cfg.settings.modifyer.mainMod}, V, togglefloating,"
            "${cfg.settings.modifyer.mainMod}, P, pseudo,"
            "${cfg.settings.modifyer.mainMod}, J, togglesplit,"
            "${cfg.settings.modifyer.mainMod}, F, fullscreen,"
            "${cfg.settings.modifyer.mainMod}, G, exec, ${gamemode_script}"
            "${cfg.settings.modifyer.mainMod}, F1, exec, ${hyprlock}"

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
            "${cfg.settings.modifyer.mainMod}, minus, exec, ${scratchpad}"
            "${cfg.settings.modifyer.mainModShift}, minus, exec, [float; center; focus] ${lib.getExe cfg.settings.defaultPrograms.terminal} start ${scratchpad} -g -m ${lib.getExe pkgs.unstable.skim}"
            "${cfg.settings.modifyer.mainModCtrl}, minus, exec, ${scratchpad} -t"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "${cfg.settings.modifyer.mainMod}, ${ws}, workspace, ${toString (x + 1)}"
                "${cfg.settings.modifyer.mainModCtrl}, ${ws}, movetoworkspace, ${toString (x + 1)}"
                "${cfg.settings.modifyer.mainModShift}, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            )
            10
          ))
          ++ lib.optionals (cfg.settings.defaultPrograms.terminal != null) [
            "${cfg.settings.modifyer.mainMod}, RETURN, exec, ${lib.getExe cfg.settings.defaultPrograms.terminal}"
          ]
          ++ lib.optionals (cfg.settings.defaultPrograms.browser != null) [
            "${cfg.settings.modifyer.mainMod}, B, exec, ${lib.getExe cfg.settings.defaultPrograms.browser}"
          ]
          ++ lib.optionals (cfg.settings.defaultPrograms.launcher != null) [
            "${cfg.settings.modifyer.mainMod}, D, exec, ${lib.getExe cfg.settings.defaultPrograms.launcher}"
          ]
          ++ lib.optionals (cfg.settings.defaultPrograms.secondaryLauncher != null) [
            "${cfg.settings.modifyer.mainModShift}, D, exec, ${lib.getExe cfg.settings.defaultPrograms.secondaryLauncher}"
          ]
          ++ lib.optionals (cfg.settings.defaultPrograms.explorer != null) [
            "${cfg.settings.modifyer.mainMod}, E, exec, ${lib.getExe cfg.settings.defaultPrograms.explorer}"
          ]
          ++ lib.optionals (cfg.settings.defaultPrograms.terminal != null && clipcat-menu != null) [
            "${cfg.settings.modifyer.mainMod}, C, exec, [float; center; focus] ${lib.getExe cfg.settings.defaultPrograms.terminal} start ${clipcat-menu}"
          ];
        bindm = [
          "${cfg.settings.modifyer.mainMod}, mouse:272, movewindow"
          "${cfg.settings.modifyer.mainMod}, mouse:273, resizewindow"
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${playerctl} play-pause"
          ", XF86AudioPrev, exec, ${playerctl} previous"
          ", XF86AudioNext, exec, ${playerctl} next"
        ];
      };
    };
  };
}
