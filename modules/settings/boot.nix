{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "settings.boot";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      plymouth = boolOption false;
      secureBoot = bootOption false;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages =
      [
        pkgs.efibootmgr
        pkgs.efitools
        pkgs.efivar
        pkgs.fwupd
      ]
      ++ lib.optionals cfg.secureBoot [pkgs.sbctl];

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
        pkiBundle = "/etc/secureboot";
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
        # theme = "catppuccin-macchiato";
        # themePackages = [ pkgs.catppuccin-plymouth ];
      };
    };
    security.tpm2.enable = true;
    security.tpm2.tctiEnvironment.enable = true;

    services.fwupd.enable = true;
  };
}
