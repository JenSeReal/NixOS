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
    programs = lib.makeBinPath (
      with pkgs; [
        hyprland
        coreutils
        libnotify
        gawk
        procps
        util-linux
        findutils
        systemd
      ]
    );

    defaultStartScript = ''
      export PATH=$PATH:${programs}

      LOG_FILE="$XDG_RUNTIME_DIR/gamemode-start.log"
      echo "=== Gamemode Start: $(date) ===" > "$LOG_FILE"
      echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> "$LOG_FILE"

      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n 1)

      echo "HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE" >> "$LOG_FILE"

      if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "Setting Hyprland optimizations..." >> "$LOG_FILE"
        hyprctl --batch '${
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
      }' 2>&1 | tee -a "$LOG_FILE" || echo "✗ Hyprctl failed" >> "$LOG_FILE"
      else
        echo "⚠ Hyprland instance not detected, skipping compositor optimizations" >> "$LOG_FILE"
      fi

      echo "=== Gamemode Start Complete ===" >> "$LOG_FILE"
      echo "GameMode will handle GPU performance and process priorities" >> "$LOG_FILE"
      notify-send -a 'Gamemode' 'Optimizations activated' -u 'low'
    '';

    defaultEndScript = ''
      export PATH=$PATH:${programs}

      # Ensure XDG_RUNTIME_DIR is set (gamemode might not have it in environment)
      if [ -z "$XDG_RUNTIME_DIR" ]; then
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      fi

      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n 1)

      LOG_FILE="$XDG_RUNTIME_DIR/gamemode-end.log"
      echo "=== Gamemode End: $(date) ===" > "$LOG_FILE"
      echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> "$LOG_FILE"
      echo "HYPRLAND_INSTANCE_SIGNATURE=$HYPRLAND_INSTANCE_SIGNATURE" >> "$LOG_FILE"

      if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "Restoring Hyprland settings..." >> "$LOG_FILE"
        hyprctl --batch '${
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
      }' 2>&1 | tee -a "$LOG_FILE" || echo "✗ Hyprctl failed" >> "$LOG_FILE"
      else
        echo "⚠ Hyprland instance not detected, skipping compositor restore" >> "$LOG_FILE"
      fi

      echo "=== Gamemode End Complete ===" >> "$LOG_FILE"
      echo "GameMode will handle GPU and process priority restoration" >> "$LOG_FILE"
      notify-send -a 'Gamemode' 'Optimizations deactivated' -u 'low'
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
          renice = 10;
          ioprio = 0;
          inhibit_screensaver = 1;
          disable_splitlock = 1;
        };

        cpu = {
          park_cores = "no"; # Don't park cores
          pin_cores = "yes"; # Pin game to optimal cores (auto-detected)
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "auto";
        };

        custom = {
          start = startScript.outPath;
          end = endScript.outPath;
        };
      };
    };

    # Add user to video and gamemode groups
    myconfig.user.extraGroups = ["video" "gamemode"];

    # Security wrapper for gamemode with necessary capabilities
    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    # Polkit rules to allow users group to use gamemode helpers
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "com.feralinteractive.GameMode.governor-helper" ||
             action.id == "com.feralinteractive.GameMode.procsys-helper" ||
             action.id == "com.feralinteractive.GameMode.gpu-helper") &&
            subject.isInGroup("users")) {
          return polkit.Result.YES;
        }
      });
    '';

    # tmpfiles rule for Intel RAPL power monitoring permissions
    systemd.tmpfiles.settings."10-gamemode-powercap" = {
      "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj".z = {
        mode = "0644";
      };
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
