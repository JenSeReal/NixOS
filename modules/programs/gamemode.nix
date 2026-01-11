{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.gamemode";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      startscript = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "The script to run when enabling gamemode.";
      };
      endscript = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "The script to run when disabling gamemode.";
      };
    };

  nixos.ifEnabled = {cfg, ...}: let
    hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
    notify-send = lib.getExe' pkgs.libnotify "notify-send";
    ls = lib.getExe' pkgs.coreutils "ls";
    echo = lib.getExe' pkgs.coreutils "echo";
    tee = lib.getExe' pkgs.coreutils "tee";
    pgrep = lib.getExe' pkgs.procps "pgrep";
    awk = lib.getExe pkgs.gawk;
    xargs = lib.getExe' pkgs.findutils "xargs";
    renice = lib.getExe' pkgs.util-linux "renice";

    defaultStartScript = ''
      export HYPRLAND_INSTANCE_SIGNATURE=$(command ${ls} -t $XDG_RUNTIME_DIR/hypr | head -n 1)

      LOG_FILE="$XDG_RUNTIME_DIR/gamemode-start.log"
      ${echo} "=== Gamemode Start: $(date) ===" > "$LOG_FILE"

      ${hyprctl} --batch '${
        lib.concatStringsSep " " [
          "keyword animations:enabled 0;"
          "keyword decoration:shadow:enabled 0;"
          "keyword decoration:blur:enabled 0;"
          "keyword decoration:active_opacity 1.0;"
          "keyword decoration:inactive_opacity 1.0;"
          "keyword decoration:fullscreen_opacity 1.0;"
          "keyword misc:vfr 0;"
          "keyword misc:vrr 0"
        ]
      }'

      ${echo} "Setting AMD GPU to high performance..." >> "$LOG_FILE"
      ${echo} performance | ${tee} /sys/class/drm/card*/device/power_dpm_force_performance_level 2>&1 | ${tee} -a "$LOG_FILE" || ${echo} "✗ GPU performance mode failed" >> "$LOG_FILE"

      {
        GAME_PIDS=$(${pgrep} -af 'steam_.*game|proton|wine-preloader|wine64-preloader|lutris|heroic|gamemoderun' | ${awk} '{print $1}')
        if [ -n "$GAME_PIDS" ]; then
          ${echo} "$GAME_PIDS" | ${xargs} -r ${renice} -n -10 -p
          ${echo} "Boosted priority for PIDs: $GAME_PIDS" >> "$LOG_FILE"
        else
          ${echo} "No game processes found to boost" >> "$LOG_FILE"
        fi
      } 2>&1 | ${tee} -a "$LOG_FILE" || true

      ${echo} "=== Gamemode Start Complete ===" >> "$LOG_FILE"
      ${notify-send} -a 'Gamemode' 'Optimizations activated' -u 'low'
    '';

    defaultEndScript = ''
      export HYPRLAND_INSTANCE_SIGNATURE=$(command ${ls} -t $XDG_RUNTIME_DIR/hypr | head -n 1)

      LOG_FILE="$XDG_RUNTIME_DIR/gamemode-end.log"
      ${echo} "=== Gamemode End: $(date) ===" > "$LOG_FILE"

      ${hyprctl} --batch '${
        lib.concatStringsSep " " [
          "keyword animations:enabled 1;"
          "keyword decoration:shadow:enabled 1;"
          "keyword decoration:blur:enabled 1;"
          "keyword decoration:active_opacity 0.95;"
          "keyword decoration:inactive_opacity 0.9;"
          "keyword decoration:fullscreen_opacity 1.0;"
          "keyword misc:vfr 1;"
          "keyword misc:vrr 2"
        ]
      }'

      ${echo} "Restoring AMD GPU to auto mode..." >> "$LOG_FILE"
      ${echo} auto | ${tee} /sys/class/drm/card*/device/power_dpm_force_performance_level 2>&1 | ${tee} -a "$LOG_FILE" || ${echo} "✗ GPU auto mode restore failed" >> "$LOG_FILE"

      {
        GAME_PIDS=$(${pgrep} -af 'steam_.*game|proton|wine-preloader|wine64-preloader|lutris|heroic|gamemoderun' | ${awk} '{print $1}')
        if [ -n "$GAME_PIDS" ]; then
          ${echo} "$GAME_PIDS" | ${xargs} -r ${renice} -n 0 -p
          ${echo} "Restored priority for PIDs: $GAME_PIDS" >> "$LOG_FILE"
        else
          ${echo} "No game processes found to restore" >> "$LOG_FILE"
        fi
      } 2>&1 | ${tee} -a "$LOG_FILE" || true

      ${echo} "=== Gamemode End Complete ===" >> "$LOG_FILE"
      ${notify-send} -a 'Gamemode' 'Optimizations deactivated' -u 'low'
    '';

    startScript =
      if (cfg.startscript == null)
      then pkgs.writeShellScript "gamemode-start" defaultStartScript
      else pkgs.writeShellScript "gamemode-start" cfg.startscript;

    endScript =
      if (cfg.endscript == null)
      then pkgs.writeShellScript "gamemode-end" defaultEndScript
      else pkgs.writeShellScript "gamemode-end" cfg.endscript;
  in {
    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };

        custom = {
          start = startScript.outPath;
          end = endScript.outPath;
        };
      };
    };

    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    # https://www.phoronix.com/news/Fedora-39-VM-Max-Map-Count
    # https://github.com/pop-os/default-settings/blob/master_jammy/etc/sysctl.d/10-pop-default-settings.conf
    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };
  };
}
