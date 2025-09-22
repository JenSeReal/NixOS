{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "power-management";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: let
    # The auto-switch script
    powerProfileScript = pkgs.writeScriptBin "power-profile-auto" ''
      #!${pkgs.bash}/bin/bash

      # Get AC adapter status
      # You might need to adjust the AC adapter name (AC, ACAD, AC0, etc.)
      # Run: ls /sys/class/power_supply/ to find your adapter name
      AC_ADAPTER="AC"  # Change this to your AC adapter name

      if [ -f "/sys/class/power_supply/$AC_ADAPTER/online" ]; then
          AC_STATUS=$(cat "/sys/class/power_supply/$AC_ADAPTER/online")
      else
          # Fallback: try common AC adapter names
          for adapter in AC ACAD AC0 ADP0 ADP1; do
              if [ -f "/sys/class/power_supply/$adapter/online" ]; then
                  AC_STATUS=$(cat "/sys/class/power_supply/$adapter/online")
                  AC_ADAPTER="$adapter"
                  break
              fi
          done
      fi

      # Log the current status
      ${pkgs.util-linux}/bin/logger "Power Profile Auto: AC adapter $AC_ADAPTER status: $AC_STATUS"

      if [ "$AC_STATUS" = "1" ]; then
          # AC connected - switch to performance
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
          ${pkgs.util-linux}/bin/logger "Power Profile Auto: Switched to performance mode (AC connected)"
      elif [ "$AC_STATUS" = "0" ]; then
          # AC disconnected - switch to power-saver
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
          ${pkgs.util-linux}/bin/logger "Power Profile Auto: Switched to power-saver mode (battery)"
      else
          ${pkgs.util-linux}/bin/logger "Power Profile Auto: Could not determine AC status"
      fi
    '';
  in {
    # https://github.com/nickhartjes/nixos-config/blob/main/hosts/framework-13/configuration.nix
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services.power-profiles-daemon.enable = true;

    services.udev.extraRules = ''
      # Auto-switch power profiles on AC/Battery
      # Triggers when power supply changes
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ACTION=="change", RUN+="${lib.getExe powerProfileScript}"
    '';

    # Create the systemd service for boot-time execution
    systemd.services.power-profile-auto = {
      description = "Auto Switch Power Profiles on Boot";
      wantedBy = ["multi-user.target"];
      after = ["power-profiles-daemon.service"];
      requires = ["power-profiles-daemon.service"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe powerProfileScript}";
        User = "root";
      };
    };
  };

  nixos.ifDisabled.powerManagement.enable = false;

  darwin.always = {
    power.sleep.computer = 5;
    power.sleep.display = 2;
  };
}
