{
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkIf
    ;

  hyprctl = getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  scratchpad = getExe inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad;
  playerctl = getExe pkgs.playerctl;
  wpctl = getExe' pkgs.wireplumber "wpctl";
  clipcat-menu = getExe' pkgs.clipcat "clipcat-menu";

  reload_script = pkgs.writeShellScript "reload.sh" ''
    killall .waybar-wrapped
    ${getExe config.programs.waybar.package} &

    hyprctl reload

    systemctl --user restart kanshi.service

    ${hyprctl} dispatch dpms on
  '';

  # Helper function to process an individual submap
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

  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in {
  options.JenSeReal.desktop.window-managers.hyprland = {
    settings = lib.mkOption {
      type = (import ./modules/settings.nix {inherit lib pkgs namespace;}).settingsModule;
      default = {};
      description = "The settings for bindings";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        ${lib.concatMapStringsSep "\n\n" processSubmap cfg.settings.submaps}
      '';

      settings = {
        bind =
          [
            "${cfg.settings.modifyer.mainMod}, RETURN, exec, ${getExe cfg.settings.defaultPrograms.terminal}"
            "${cfg.settings.modifyer.mainMod}, B, exec, ${getExe cfg.settings.defaultPrograms.browser}"
            "${cfg.settings.modifyer.mainMod}, D, exec, ${getExe cfg.settings.defaultPrograms.launcher}"
            "${cfg.settings.modifyer.mainModShift}, D, exec, ${getExe cfg.settings.defaultPrograms.secondaryLauncher}"
            "${cfg.settings.modifyer.mainMod}, E, exec, ${getExe cfg.settings.defaultPrograms.explorer}"
            "${cfg.settings.modifyer.mainMod}, C, exec, [float; center; focus] ${getExe cfg.settings.defaultPrograms.terminal} start ${clipcat-menu}"

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
            "${cfg.settings.modifyer.mainMod}, minus, exec, ${scratchpad}"
            "${cfg.settings.modifyer.mainModShift}, minus, exec, [float; center; focus] ${getExe cfg.settings.defaultPrograms.terminal} start ${scratchpad} -g -m ${getExe pkgs.unstable.skim}"
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
          ));
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
