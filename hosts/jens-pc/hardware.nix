{delib, ...}:
delib.host rec {
  name = "jens-pc";
  system = "x86_64-linux";

  home.home.stateVersion = "25.05";
  nixos = {
    # COMMENTED OUT: Disko migration requires reinstall which would erase the system
    # imports = [inputs.disko.nixosModules.disko];

    nixpkgs.hostPlatform = system;
    system.stateVersion = "25.05";

    # COMMENTED OUT: Disko disk configuration (requires reinstall)
    # disko.devices = {
    #   disk = {
    #     jens-pc-main = {
    #       type = "disk";
    #       device = "/dev/nvme0n1";
    #       content = {
    #         type = "gpt";
    #         partitions = {
    #           ESPPART = {
    #             size = "512M";
    #             type = "EF00";
    #             content = {
    #               type = "filesystem";
    #               format = "vfat";
    #               mountpoint = "/boot";
    #               mountOptions = ["defaults"];
    #             };
    #           };
    #           ROOTPART = {
    #             size = "100%";
    #             content = {
    #               type = "luks";
    #               name = "enc";
    #               settings.allowDiscards = true;
    #               content = {
    #                 type = "lvm_pv";
    #                 vg = "pool";
    #               };
    #             };
    #           };
    #         };
    #       };
    #     };
    #   };
    #   lvm_vg = {
    #     pool = {
    #       type = "lvm_vg";
    #       lvs = {
    #         swap = {
    #           size = "40G";
    #           content = {
    #             type = "swap";
    #             resumeDevice = true;
    #           };
    #         };
    #         root = {
    #           size = "100%FREE";
    #           content = {
    #             type = "btrfs";
    #             extraArgs = ["-f" "-L" "ROOTFS"];
    #             subvolumes = {
    #               "/root".mountpoint = "/";
    #               "/root".mountOptions = ["compress=zstd" "noatime"];
    #               "/home".mountpoint = "/home";
    #               "/home".mountOptions = ["compress=zstd" "noatime"];
    #               "/nix".mountpoint = "/nix";
    #               "/nix".mountOptions = ["compress=zstd" "noatime"];
    #               "/persist".mountpoint = "/persist";
    #               "/persist".mountOptions = ["compress=zstd" "noatime"];
    #               "/log".mountpoint = "/var/log";
    #               "/log".mountOptions = ["compress=zstd" "noatime"];
    #             };
    #           };
    #         };
    #       };
    #     };
    #   };
    # };

    boot.initrd.luks.devices."enc" = {
      device = "/dev/disk/by-partlabel/ROOTPART";
      preLVM = true;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    fileSystems."/persist" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    fileSystems."/var/log" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOTFS";
      fsType = "vfat";
    };

    swapDevices = [{device = "/dev/disk/by-label/SWAPFS";}];
  };
  darwin = {
    system.stateVersion = 6;
  };

  myconfig = {
    boot = {
      enable = true;
      plymouth = true;
      secureBoot = true;
    };
    hardware = {
      bluetooth.enable = true;
      fingerprint.enable = true;
      framework.enable = true;
      graphics.enable = true;
      touchpad.enable = true;
    };
    services = {
      btrfs.enable = true;
      fwupd.enable = true;
    };

    power-management.enable = true;
  };
}
