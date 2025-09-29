{
  delib,
  pkgs,
  lib,
  inputs,
  ...
}:
delib.module {
  name = "boot";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      plymouth = boolOption false;
      secureBoot = boolOption false;
    };

  nixos.always.imports = [inputs.lanzaboote.nixosModules.lanzaboote];
  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs;
      [
        efibootmgr
        efitools
        efivar
        fwupd
      ]
      ++ lib.optionals cfg.secureBoot [sbctl];

    boot = {
      bootspec.enable = true;
      consoleLogLevel = 0;
      initrd.verbose = false;
      supportedFilesystems = [
        "btrfs"
        "ntfs"
        "fat32"
      ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = lib.optionals cfg.plymouth [
        "quiet"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ];

      lanzaboote = lib.mkIf cfg.secureBoot {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        systemd-boot = {
          enable = !cfg.secureBoot;
          configurationLimit = 20;
          editor = false;
        };
      };

      plymouth = lib.mkIf cfg.secureBoot {
        enable = true;
      };
    };
    hardware.enableAllFirmware = true;

    security.tpm2.enable = true;
    security.tpm2.tctiEnvironment.enable = true;
  };
}
